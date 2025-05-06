class Otf2 < Formula
  desc "Open Trace Format 2 file handling library"
  homepage "https://www.vi-hps.org/projects/score-p/"
  url "https://perftools.pages.jsc.fz-juelich.de/cicd/otf2/tags/otf2-3.1.1/otf2-3.1.1.tar.gz"
  sha256 "5a4e013a51ac4ed794fe35c55b700cd720346fda7f33ec84c76b86a5fb880a6e"
  license "BSD-3-Clause"

  livecheck do
    url :homepage
    regex(/href=.*?otf2[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia: "bf03e30a4b748814623d920cf6ca4ba61462ae684a44771f989c05ba2b0934d2"
    sha256 arm64_sonoma:  "b4dff2dd5254e62c3cd810ac1c16867b18a81234d6a093ab75133d4079fe647b"
    sha256 arm64_ventura: "638de457bf40ab80944527bfd56ca70b2235b38e2a4af71f6cde66f12d2389b4"
    sha256 sonoma:        "4987fe04a326f4736ec4eeaa3d332bf8daf4b0e3683fd5349cb001161a602eb9"
    sha256 ventura:       "d6190ba13bb60f56336225dfabce7506d0cc08e70acf92ae114c93782171d279"
    sha256 arm64_linux:   "5681d5b715c4940a4abb1b0dfb8572ac775ed99f05d04fb63fa9e32203aab63d"
    sha256 x86_64_linux:  "9b35e4c7047c6fbe7ff749e16f4f900710005fa459230f0db3281bb433b8f149"
  end

  depends_on "python-setuptools" => :build
  depends_on "sphinx-doc" => :build
  depends_on "gcc" # for gfortran
  depends_on "open-mpi"
  depends_on "python@3.13"

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
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
    "python3.13"
  end

  def install
    resource("six").stage do
      system python3, "-m", "pip", "install", *std_pip_args(prefix: libexec), "."
    end

    ENV.prepend_path "PYTHONPATH", libexec/Language::Python.site_packages(python3)
    ENV["PYTHON"] = which(python3)
    ENV["SPHINX"] = Formula["sphinx-doc"].opt_bin/"sphinx-build"

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
