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
    rebuild 1
    sha256 arm64_golden_gate: "ed969eb7ea11f1b0dae92542ba35a95bb0a2490ad5122246a5e7848802ff39f1"
    sha256 arm64_tahoe:       "19832cc78f09c74fcb2302f1bfca65b009ef5792b7652436b329af2d3743e0b1"
    sha256 arm64_sequoia:     "7b055aa1059dabf91b8d3a2355898d2c9aaaaf1a6e2704feba854948f97febc0"
    sha256 arm64_linux:       "e443aa8afa6f2d35aef845dcfaad48a6fda64216109cfdc92c9150adc7ceba54"
    sha256 x86_64_linux:      "1d970892175c67b95c36013f00f33a36200a64b031277c88ad6086db07e03e5b"
  end

  depends_on "sphinx-doc" => :build
  depends_on "open-mpi"
  depends_on "python@3.15"

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    file "Patches/libtool/configure-big_sur.diff"
    directory "build-frontend"
    type :unofficial
  end
  patch do
    file "Patches/libtool/configure-big_sur.diff"
    directory "build-backend"
    type :unofficial
  end

  def install
    ENV["PYTHON"] = python3
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
