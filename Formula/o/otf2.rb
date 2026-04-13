class Otf2 < Formula
  desc "Open Trace Format 2 file handling library"
  homepage "https://www.vi-hps.org/projects/score-p/overview/overview.html"
  url "https://perftools.pages.jsc.fz-juelich.de/cicd/otf2/tags/otf2-3.1.1/otf2-3.1.1.tar.gz"
  sha256 "5a4e013a51ac4ed794fe35c55b700cd720346fda7f33ec84c76b86a5fb880a6e"
  license "BSD-3-Clause"

  livecheck do
    url "https://www.vi-hps.org/projects/score-p/download/download.html"
    regex(/href=.*?otf2[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 2
    sha256 arm64_tahoe:   "76c5a0d7064c8b0d2b4feba19fba8ae8843e3085f37be9c9c6010d944496fa65"
    sha256 arm64_sequoia: "d170f775b42d56dc661464910a75dc8f2a1eb5cf5af8324b6eee25aeb753129b"
    sha256 arm64_sonoma:  "187ee8044d67eef1e06e8acc1d13753741f69653cc7c4939fca07df504dfc092"
    sha256 sonoma:        "1eb5144ac0c5dce41f43eadefccd0f0139da021e427021e0686ed160598d755d"
    sha256 arm64_linux:   "db40af1b5f5e1d6e05658e4d98cb35bf87af8fd2c6e02ee26b5906034a8bd611"
    sha256 x86_64_linux:  "68b504e18ca81ea5cf975e01c12db1df9d8e54a049612a478f627672159bd9fc"
  end

  depends_on "sphinx-doc" => :build
  depends_on "open-mpi"
  depends_on "python@3.14"

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/homebrew-core/1cf441a0/Patches/libtool/configure-big_sur.diff"
    sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
    directory "build-frontend"
  end
  patch do
    url "https://raw.githubusercontent.com/Homebrew/homebrew-core/1cf441a0/Patches/libtool/configure-big_sur.diff"
    sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
    directory "build-backend"
  end

  def python3
    "python3.14"
  end

  def install
    ENV["PYTHON"] = which(python3)
    ENV["SPHINX"] = Formula["sphinx-doc"].opt_bin/"sphinx-build"

    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make"
    system "make", "install"

    inreplace pkgshare/"otf2.summary", "#{Superenv.shims_path}/", ""
  end

  test do
    cp_r share/"doc/otf2/examples", testpath
    workdir = testpath/"examples"
    chdir "#{testpath}/examples" do
      # build serial tests
      system "make", "serial", "mpi", "pthread"
      %w[
        otf2_mpi_reader_example
        otf2_mpi_reader_example_cc
        otf2_mpi_writer_example
        otf2_pthread_writer_example
        otf2_reader_example
        otf2_writer_example
      ].each { |p| assert_path_exists workdir/p }
      system "./otf2_writer_example"
      assert_path_exists workdir/"ArchivePath/ArchiveName.otf2"
      system "./otf2_reader_example"
      rm_r("./ArchivePath")
      system Formula["open-mpi"].opt_bin/"mpirun", "-n", "2", "./otf2_mpi_writer_example"
      assert_path_exists workdir/"ArchivePath/ArchiveName.otf2"
      2.times do |n|
        assert_path_exists workdir/"ArchivePath/ArchiveName/#{n}.evt"
      end
      system Formula["open-mpi"].opt_bin/"mpirun", "-n", "2", "./otf2_mpi_reader_example"
      system "./otf2_reader_example"
      rm_r("./ArchivePath")
      system "./otf2_pthread_writer_example"
      assert_path_exists workdir/"ArchivePath/ArchiveName.otf2"
      system "./otf2_reader_example"
    end

    ENV.prepend_path "PYTHONPATH", libexec/Language::Python.site_packages(python3)
    system python3, "-c", "import otf2"
  end
end
