class Nextdenovo < Formula
  include Language::Python::Shebang
  include Language::Python::Virtualenv

  desc "Fast and accurate de novo assembler for long reads"
  homepage "https://github.com/Nextomics/NextDenovo"
  url "https://github.com/Nextomics/NextDenovo/archive/refs/tags/2.5.2.tar.gz"
  sha256 "f1d07c9c362d850fd737c41e5b5be9d137b1ef3f1aec369dc73c637790611190"
  license "GPL-3.0-only"

  depends_on "python@3.14"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  pypi_packages package_name:   "",
                extra_packages: "paralleltask"

  resource "paralleltask" do
    url "https://files.pythonhosted.org/packages/c1/14/7384ac9eac759d286e94f5456c82335dd268495294cbcc1a0e5d647ecffa/Paralleltask-0.2.3.tar.gz"
    sha256 "8015a8311d5021bc44edbfbf45ff2557a529999e235d25190bac62993fdf7b66"
  end

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/aa/c6/d1ddf4abb55e93cebc4f2ed8b5d6dbad109ecb8d63748dd2b20ab5e57ebe/psutil-7.2.2.tar.gz"
    sha256 "0746f5f8d406af344fd547f1c8daa5f5c33dbc293bb8d6a16d80b4bb88f59372"
  end

  # Although the resources are listed above, pip still needs to fetch
  # their chosen build system via the network.
  deny_network_access! [:postinstall, :test]

  def install
    # The bundled htslib 1.9 is used because lib/bsort.c (derived from samtools 1.9)
    # relies on header APIs whose behaviour changed in newer htslib releases.
    # NDEBUG drops its `compressBound` assertion, which fails with zlib-ng
    # (removed upstream in newer htslib releases).
    cd "lib/htslib" do
      system "./configure", "--disable-bz2", "--disable-lzma", "--disable-libcurl",
                            "--disable-gcs", "--disable-s3", "--without-libdeflate"
      system "make", "lib-static", "CPPFLAGS=-fPIC -DNDEBUG"
    end
    # `_POSIX_C_SOURCE` hides `pthread_setname_np` on macOS
    inreplace "util/Makefile", "-Wno-unused-function", "-Wno-unused-function -D_DARWIN_C_SOURCE" if OS.mac?
    # The Python workers rely on globals inherited through `fork`, which is no longer
    # the default multiprocessing start method on macOS or on Linux with Python 3.14.
    inreplace %w[lib/ctg_cns.py lib/nextcorrect.py], "from multiprocessing import Pool",
              "from multiprocessing import get_context\nPool = get_context(\"fork\").Pool"

    # The Makefiles call `make` rather than `$(MAKE)` for subdirectories,
    # which breaks the jobserver in parallel builds
    ENV.deparallelize
    args = ["CC=#{ENV.cc}"]
    args += %w[arm_neon=1 aarch64=1] if Hardware::CPU.arm?
    system "make", *args

    libexec.install "bin", "nextDenovo", "VERSION"
    (libexec/"lib").install Dir["lib/*.py", "lib/*.so"]

    venv = virtualenv_create(libexec/"venv", "python3.14")
    venv.pip_install resources
    rewrite_shebang python_shebang_rewrite_info(venv.root/"bin/python"), libexec/"nextDenovo"
    bin.install_symlink libexec/"nextDenovo"

    pkgshare.install "test_data"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/nextDenovo --version")

    cp pkgshare/"test_data/reads_test.fa.gz", testpath
    (testpath/"input.fofn").write "reads_test.fa.gz\n"
    # `ctg_cns_options -a` disables the RAM-based adjustment of the process count,
    # which drops it to zero on machines with less than about 8 GB of free memory
    (testpath/"run.cfg").write <<~INI
      [General]
      job_type = local
      task = all
      rewrite = yes
      deltmp = yes
      parallel_jobs = 2
      input_type = raw
      read_type = clr
      input_fofn = input.fofn
      workdir = rundir

      [correct_option]
      read_cutoff = 1k
      genome_size = 308161
      pa_correction = 2
      sort_options = -m 1g -t 2
      minimap2_options_raw = -t 4
      correction_options = -p 4

      [assemble_option]
      minimap2_options_cns = -t 4
      nextgraph_options = -a 1
      ctg_cns_options = -p 2 -a
    INI
    system bin/"nextDenovo", "run.cfg"
    assert_match(/^>ctg000000/, (testpath/"rundir/03.ctg_graph/nd.asm.fasta").read)
  end
end
