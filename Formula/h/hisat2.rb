class Hisat2 < Formula
  include Language::Python::Shebang

  desc "Graph-based alignment to a population of genomes"
  homepage "https://daehwankimlab.github.io/hisat2/"
  url "https://github.com/DaehwanKimLab/hisat2/archive/refs/tags/v2.2.2.tar.gz"
  sha256 "d3996d7bee30e38e51beb69c44b10461a4692e686487c465f9a20e3f54b6e815"
  license "GPL-3.0-or-later"
  head "https://github.com/DaehwanKimLab/hisat2.git", branch: "master"

  depends_on "python@3.14"

  on_arm do
    depends_on "sse2neon" => :build
  end

  def install
    # On case-insensitive filesystems the VERSION file shadows <version>, giving
    # "./VERSION:1:1: error: expected unqualified-id"; it is only used by the
    # packaging targets we do not build.
    rm "VERSION" if OS.mac?
    # -msse2 is x86-only and no longer needed (SIMD is autodetected).
    inreplace "Makefile", "-msse2", ""
    # third_party only provides an x86 cpuid.h that is not needed.
    inreplace "Makefile", "-I third_party", ""
    # POPCNT_CAPABILITY is not supported on ARM.
    inreplace "Makefile", "-DPOPCNT_CAPABILITY ", ""
    inreplace ["aligner_sw.h", "sse_util.h"], "#include <emmintrin.h>", "#include <sse2neon.h>" if Hardware::CPU.arm?
    inreplace "processor_support.h" do |s|
      s.gsub! "#elif defined(__GNUC__)", "#elif defined(__GNUC__) && (defined(__amd64__) || defined(__i386__))"
      s.gsub! 'std::cerr << "ERROR: please define __cpuid() for this build.\n"; ', ""
      s.gsub! "assert(0);", "return false;"
    end
    system "make"
    rm "HISAT2-genotype.png"
    bin.install "hisat2", Dir["hisat2-*"], Dir["hisat2_*.py"]
    bin.find { |f| rewrite_shebang detected_python_shebang, f }
    doc.install Dir["docs/*"]
    pkgshare.install "example", "scripts"
  end

  test do
    system bin/"hisat2-build", "-p", "12", pkgshare/"example/reference/22_20-21M.fa", "genome_index"
    assert_path_exists testpath/"genome_index.1.ht2"
  end
end
