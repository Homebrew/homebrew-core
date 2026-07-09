class Otf2 < Formula
  desc "Open Trace Format 2 file handling library"
  homepage "https://www.vi-hps.org/projects/score-p/overview/overview.html"
  url "https://perftools.pages.jsc.fz-juelich.de/cicd/otf2/tags/otf2-3.2/otf2-3.2.tar.gz"
  sha256 "82b3a88a550cb8c3cec8fd45eca82cdcbaf945209977482471b4b5e430d64a8d"
  license "BSD-3-Clause"

  livecheck do
    url "https://www.vi-hps.org/projects/score-p/download/download.html"
    regex(/href=.*?otf2[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "35278dc5769e0222e034307e2882bd070e987c191912f0d7620267ec8ed9bf2f"
    sha256 arm64_sequoia: "f4b0509ef762a1f4e6bf003b27f3efe1071d5ae5e71675ab99c5df17b9f74348"
    sha256 arm64_sonoma:  "d1ff3b7df78614ae970983220609c607306da8d7a6f716138750c8f93f87704b"
    sha256 sonoma:        "e4b55ced4491b7d5079ccdb79d27996ac8d13b7aa4859c46fb3520f3dfed0aca"
    sha256 arm64_linux:   "86af0058db787e9b87b08a1d2c261e26f1f0cfb77234ea8f68305683a0ce8b2d"
    sha256 x86_64_linux:  "d6abbaad20c450ecc3f6a728ee246e51f7b8c79c05b9c75879aebffb7b2908a2"
  end

  depends_on "sphinx-doc" => :build
  depends_on "open-mpi"
  depends_on "python@3.14"

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    file "Patches/libtool/configure-big_sur.diff"
    directory "build-frontend"
  end
  patch do
    file "Patches/libtool/configure-big_sur.diff"
    directory "build-backend"
  end

  def python3
    "python3.14"
  end

  def install
    ENV["PYTHON"] = which(python3)
    ENV["SPHINX"] = formula_opt_bin("sphinx-doc")/"sphinx-build"

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
      system formula_opt_bin("open-mpi")/"mpirun", "-n", "2", "./otf2_mpi_writer_example"
      assert_path_exists workdir/"ArchivePath/ArchiveName.otf2"
      2.times do |n|
        assert_path_exists workdir/"ArchivePath/ArchiveName/#{n}.evt"
      end
      system formula_opt_bin("open-mpi")/"mpirun", "-n", "2", "./otf2_mpi_reader_example"
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
