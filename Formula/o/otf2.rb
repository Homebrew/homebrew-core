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
    rebuild 1
    sha256 arm64_tahoe:   "0699ada7968a7a8bac23d0a2e120d325e36f8a0aeb5637b91fb71acacfdc05ff"
    sha256 arm64_sequoia: "a62f6852a4714aee63e80f10cfdd27b008c4ff5984d8a3e859baeacbc08dc42f"
    sha256 arm64_sonoma:  "3472c030be39bc7430179ae6d1028d4ac3539e9229dee0d86a4f95077ef898f4"
    sha256 sonoma:        "a1d4ee581094663d2042211869b0ad1009d7213a3df6b51d7152d2a855a4aeef"
    sha256 arm64_linux:   "a92b2db2f4624d69504d3cc37d88e25553ccd507e2b2b4abc1e248e1147a2523"
    sha256 x86_64_linux:  "966abf2c53bb4dd7f566b972e2b1c7defb27e37bdd0b5771b6acec6fc8752fe4"
  end

  depends_on "python-setuptools" => :build
  depends_on "sphinx-doc" => :build
  depends_on "open-mpi"
  depends_on "python@3.14"

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

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
