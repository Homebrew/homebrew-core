class Otf2 < Formula
  desc "Open Trace Format 2 file handling library"
  homepage "https://www.vi-hps.org/projects/score-p/"
  # TODO: check if we can remove `autoconf` + `automake` at version bump.
  url "https://perftools.pages.jsc.fz-juelich.de/cicd/otf2/tags/otf2-3.0.3/otf2-3.0.3.tar.gz", using: :homebrew_curl
  sha256 "18a3905f7917340387e3edc8e5766f31ab1af41f4ecc5665da6c769ca21c4ee8"
  license "BSD-3-Clause"

  livecheck do
    url :homepage
    regex(/href=.*?otf2[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 2
    sha256 arm64_sequoia:  "9d97ad4308648acfa2192bb8abd4216543babca9c937f2d888274202e3b442f8"
    sha256 arm64_sonoma:   "80ae5483e293499a103208036e71dfc89bb3d6a07c5db49b7a4542fa9f4fa5bb"
    sha256 arm64_ventura:  "3025d4a7f4abb1bb0daf3f63242cfb3587106ce2841c9974ca88272ca5db1459"
    sha256 arm64_monterey: "d27a2cf721638980b8068b1ec834d7fd791d93a00351ee18ed59c47c27a7a5eb"
    sha256 sonoma:         "73c03d86d35a0685c3d90c517a6add5d5894ec7c9c4a89dead273730c6b5ef99"
    sha256 ventura:        "64e94d9dc3a7e0628120b88f25f454a71f0bb45a130c95a0f15b503601419458"
    sha256 monterey:       "8d75fac976ffd59b903d10ed0b227e934cf48f9bae5d62e6e3305f8f121915dc"
    sha256 x86_64_linux:   "0e70a12bcdf95ec85041668d67b6344fd64c0fb368126c61c18899b666f6a948"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "python-setuptools" => :build
  depends_on "sphinx-doc" => :build
  depends_on "gcc" # for gfortran
  depends_on "open-mpi"
  depends_on "python@3.12"

  resource "six" do
    url "https://files.pythonhosted.org/packages/71/39/171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85e/six-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

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

  def python3
    "python3.12"
  end

  def install
    resource("six").stage do
      system python3, "-m", "pip", "install", *std_pip_args(prefix: libexec), "."
    end

    ENV.prepend_path "PYTHONPATH", libexec/Language::Python.site_packages(python3)
    ENV["PYTHON"] = which(python3)
    ENV["SPHINX"] = Formula["sphinx-doc"].opt_bin/"sphinx-build"

    # Bundled `build-config/py-compile` isn't compatabile with python 3.12 due to `imp` usage
    # TODO: check if we can remove this and `autoconf` + `automake` deps
    system "autoreconf", "--force", "--install", "--verbose"
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make"
    system "make", "install"

    inreplace pkgshare/"otf2.summary", "#{Superenv.shims_path}/", ""
  end

  def caveats
    <<~EOS
      To use the Python bindings, you will need to have the six library.
      One option is to use the bundled copy through your PYTHONPATH, e.g.
        export PYTHONPATH=#{opt_libexec/Language::Python.site_packages(python3)}
    EOS
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
      ].each { |p| assert_predicate workdir/p, :exist? }
      system "./otf2_writer_example"
      assert_predicate workdir/"ArchivePath/ArchiveName.otf2", :exist?
      system "./otf2_reader_example"
      rm_r("./ArchivePath")
      system Formula["open-mpi"].opt_bin/"mpirun", "-n", "2", "./otf2_mpi_writer_example"
      assert_predicate workdir/"ArchivePath/ArchiveName.otf2", :exist?
      2.times do |n|
        assert_predicate workdir/"ArchivePath/ArchiveName/#{n}.evt", :exist?
      end
      system Formula["open-mpi"].opt_bin/"mpirun", "-n", "2", "./otf2_mpi_reader_example"
      system "./otf2_reader_example"
      rm_r("./ArchivePath")
      system "./otf2_pthread_writer_example"
      assert_predicate workdir/"ArchivePath/ArchiveName.otf2", :exist?
      system "./otf2_reader_example"
    end

    ENV.prepend_path "PYTHONPATH", libexec/Language::Python.site_packages(python3)
    system python3, "-c", "import otf2"
  end
end
