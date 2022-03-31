class Otf2 < Formula
  desc "Open Trace Format 2 file handling library"
  homepage "https://www.vi-hps.org/projects/score-p/"
  url "https://perftools.pages.jsc.fz-juelich.de/cicd/otf2/tags/otf2-3.0/otf2-3.0.tar.gz", using: :homebrew_curl
  sha256 "6fff0728761556e805b140fd464402ced394a3c622ededdb618025e6cdaa6d8c"
  license "BSD-3-Clause"

  livecheck do
    url :homepage
    regex(/href=.*?otf2[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "b180ac7759220e22a75e055c8fea8ecba5665d4fe0b6efc751518ba5520dc8fb"
    sha256 arm64_big_sur:  "8662b77af43c3692b6e46cc238971ec5fc7285611318dd22b6cf7494eeaab245"
    sha256 monterey:       "05ed254d8c1dec8760bd565d07715226f0466f10d11affcbef35a9718864c30a"
    sha256 big_sur:        "95502a9bcfe892e2d14c0915f81f1b1b80351496f31d049741b793b3de1343ef"
    sha256 catalina:       "5d0dee1bdd5512982dc5aab82faf3f3d620e2d223c8e0924d6cebb345e054554"
    sha256 mojave:         "6b6c453bf295b0c846a30341ab449e4584a5530c36a11092cf280d0722e86305"
    sha256 x86_64_linux:   "1d50206940aff9bd6e75c8ee1ad88b274aa129bc8c3d7348f7e0d0064fd1673c"
  end

  depends_on "sphinx-doc" => :build
  depends_on "gcc" # for gfortran
  depends_on "open-mpi"
  depends_on "python@3.10"
  depends_on "six"

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-big_sur.diff"
    sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
    directory "build-frontend"
  end
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-big_sur.diff"
    sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
    directory "build-backend"
  end

  def install
    ENV["PYTHON"] = which("python3")
    ENV["SPHINX"] = Formula["sphinx-doc"].opt_bin/"sphinx-build"

    system "./configure", *std_configure_args, "--disable-silent-rules"
    system "make"
    system "make", "install"

    inreplace pkgshare/"otf2.summary", "#{Superenv.shims_path}/", ""
  end

  test do
    cp_r share/"doc/otf2/examples", testpath
    workdir = testpath/"examples"
    chdir "#{testpath}/examples" do
      # Use -std=gnu99 to work around Linux error when compiling with -std=c99, which
      # requires _POSIX_C_SOURCE >= 199309L in order to use POSIX time functions/macros.
      inreplace "Makefile", "-std=c99", "-std=gnu99" if OS.linux?
      # build serial tests
      system "make", "serial", "mpi", "pthread"
      %w[
        otf2_mpi_reader_example
        otf2_mpi_reader_example_cc
        otf2_mpi_writer_example
        otf2_pthread_writer_example
        otf2_reader_example
        otf2_writer_example
      ].each { |p| assert_predicate workdir/p, :exist? }
      system "./otf2_writer_example"
      assert_predicate workdir/"ArchivePath/ArchiveName.otf2", :exist?
      system "./otf2_reader_example"
      rm_rf "./ArchivePath"
      system Formula["open-mpi"].opt_bin/"mpirun", "-n", "2", "./otf2_mpi_writer_example"
      assert_predicate workdir/"ArchivePath/ArchiveName.otf2", :exist?
      (0...2).each do |n|
        assert_predicate workdir/"ArchivePath/ArchiveName/#{n}.evt", :exist?
      end
      system Formula["open-mpi"].opt_bin/"mpirun", "-n", "2", "./otf2_mpi_reader_example"
      system "./otf2_reader_example"
      rm_rf "./ArchivePath"
      system "./otf2_pthread_writer_example"
      assert_predicate workdir/"ArchivePath/ArchiveName.otf2", :exist?
      system "./otf2_reader_example"
    end
  end
end
