# frozen_string_literal: true

class Nextpolish < Formula
  include Language::Python::Shebang
  include Language::Python::Virtualenv

  desc "Fast and efficient genome polishing tool for long-read assemblies"
  homepage "https://github.com/Nextomics/NextPolish"
  # The v1.4.1 tag only contains documentation; the source was published later on master.
  url "https://github.com/Nextomics/NextPolish/archive/cfa7b1b1de93a46d2a24195ba1a7732631d35bee.tar.gz"
  version "1.4.1"
  sha256 "685c30fef5071808b0868d6e6959c41d7938beecd4b2eaf283f945f1f62e222d"
  license "GPL-3.0-only"

  depends_on "python-setuptools" => :build
  depends_on "bwa"
  depends_on "htslib"
  depends_on "minimap2"
  depends_on "python@3.14"
  depends_on "samtools"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  pypi_packages package_name: "", extra_packages: "paralleltask"

  resource "paralleltask" do
    url "https://files.pythonhosted.org/packages/c1/14/7384ac9eac759d286e94f5456c82335dd268495294cbcc1a0e5d647ecffa/Paralleltask-0.2.3.tar.gz"
    sha256 "8015a8311d5021bc44edbfbf45ff2557a529999e235d25190bac62993fdf7b66"
  end

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/aa/c6/d1ddf4abb55e93cebc4f2ed8b5d6dbad109ecb8d63748dd2b20ab5e57ebe/psutil-7.2.2.tar.gz"
    sha256 "0746f5f8d406af344fd547f1c8daa5f5c33dbc293bb8d6a16d80b4bb88f59372"
  end

  deny_network_access!

  def install
    venv = virtualenv_create(libexec/"venv", "python3.14")
    venv.pip_install resources, build_isolation: false

    cd "source" do
      # `malloc.h` does not exist on macOS
      inreplace "lib/seqlist.h", "#include<malloc.h>", "#include<stdlib.h>" if OS.mac?
      # Use Homebrew's htslib instead of the vendored static copy
      inreplace "lib/Makefile", ": htslib_ ", ": "
      # Regions are 1-based: htslib >= 1.10 returns an empty sequence for `name:0-N`
      inreplace "lib/contig.c", "tigname, 0, length1", "tigname, 1, length1"
      # Workers rely on ctypes globals inherited from the parent, which needs the
      # `fork` start method (default is `spawn` on macOS and `forkserver` on Linux)
      inreplace %w[lib/nextpolish1.py lib/nextpolish2.py], "from multiprocessing import Pool",
                "from multiprocessing import get_context\nPool = get_context('fork').Pool"

      # Skip the GitHub release check made on every run
      inreplace "lib/kit.py", "latest = latestver('https://api.github.com/repos/Nextomics/NextPolish/releases/latest')",
                              "latest = 'Unknown'"

      htslib = Formula["htslib"]
      cflags = "-Wall -O3 -fPIC"
      cflags += " -D_DARWIN_C_SOURCE" if OS.mac?
      system "make", "-C", "lib", "nextpolish1.so", "nextpolish2.so", "calgs.so",
             "CC=#{ENV.cc}",
             "CFLAGS=#{cflags} -std=c99",
             "HTSLIB=#{htslib.opt_lib/shared_library("libhts")}",
             "HTSLIB_CPPFLAGS=-I#{htslib.opt_include}",
             "LIBS=-lm -lz"
      system "make", "-C", "util", "seq_split", "seq_count", "CC=#{ENV.cc}", "CFLAGS=#{cflags}"

      rewrite_shebang python_shebang_rewrite_info(venv.root/"bin/python"), "nextPolish", *Dir["lib/*.py"]

      (libexec/"lib").install Dir["lib/*.py"], Dir["lib/*.so"]
      (libexec/"bin").install "util/seq_split", "util/seq_count"
      %w[bwa minimap2 samtools].each do |tool|
        (libexec/"bin").install_symlink formula_opt_bin(tool)/tool
      end
      # The version is parsed from README.md next to the script
      libexec.install "nextPolish", "README.md"
      pkgshare.install "doc/run.cfg"
    end

    bin.install_symlink libexec/"nextPolish"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/nextPolish --version 2>&1")

    # Simulate a 10 kb genome, a draft carrying 20 substitutions and error-free paired-end reads
    rng = Random.new(42)
    truth = Array.new(10_000) { "ACGT"[rng.rand(4)] }.join
    draft = truth.dup
    (100...9_900).to_a.sample(20, random: rng).each { |pos| draft[pos] = "ACGT".delete(truth[pos])[rng.rand(3)] }
    refute_equal truth, draft
    (testpath/"draft.fa").write ">ctg1\n#{draft}\n"

    complement = { "A" => "T", "C" => "G", "G" => "C", "T" => "A" }
    r1 = []
    r2 = []
    2_000.times do |i|
      start = rng.rand(truth.length - 400)
      fragment = truth[start, 400]
      r1 << "@r#{i}/1\n#{fragment[0, 150]}\n+\n#{"I" * 150}\n"
      r2 << "@r#{i}/2\n#{fragment[-150..].reverse.chars.map { |c| complement[c] }.join}\n+\n#{"I" * 150}\n"
    end
    (testpath/"reads_1.fq").write r1.join
    (testpath/"reads_2.fq").write r2.join
    (testpath/"sgs.fofn").write "#{testpath}/reads_1.fq\n#{testpath}/reads_2.fq\n"

    (testpath/"run.cfg").write <<~INI
      [General]
      job_type = local
      task = 12
      rewrite = yes
      parallel_jobs = 1
      multithread_jobs = 2
      genome = #{testpath}/draft.fa
      genome_size = auto
      workdir = #{testpath}/rundir
      polish_options = -p {multithread_jobs}

      [sgs_option]
      sgs_fofn = #{testpath}/sgs.fofn
      sgs_options = -max_depth 100 -bwa
    INI

    system bin/"nextPolish", "run.cfg"
    polished = (testpath/"rundir/genome.nextpolish.fasta").read.lines.drop(1).join.delete("\n")
    assert_equal truth.upcase, polished.upcase
  end
end
