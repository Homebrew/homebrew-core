class Prsice < Formula
  desc "Calculate, apply and evaluate polygenic risk scores"
  homepage "https://choishingwan.github.io/PRSice/"
  url "https://github.com/choishingwan/PRSice/archive/refs/tags/2.3.5.tar.gz"
  sha256 "0a7e649ddebe4e969cd8400c5ad977a7b900be4f5c920a84483cb8930367354d"
  license "GPL-3.0-or-later"

  depends_on "cmake" => :build
  depends_on "eigen" => :build
  depends_on "simde" => :build

  uses_from_macos "zlib"

  def install
    # Build against the Eigen formula instead of fetching upstream's submodule.
    # `-DEIGEN_INCLUDE_DIR` is ignored until choishingwan/PRSice#380 lands.
    inreplace "CMakeLists.txt", "${CMAKE_CURRENT_SOURCE_DIR}/lib/eigen/",
                                formula_opt_include("eigen")/"eigen3"

    # The bundled PLINK 1.9 code predates its SIMDe fallback, so this release
    # only builds on x86_64. Upstream took the newer PLINK in
    # https://github.com/choishingwan/PRSice/commit/bccc59e8, which is not in a
    # release yet, so apply the same fallback here.
    inreplace "lib/plink_common.hpp" do |s|
      s.gsub! "#error \\\n    \"64-bit builds currently require SSE2.  " \
              "Try producing a 32-bit build instead.\"\n", ""
      s.gsub! "#include <emmintrin.h>", <<~EOS
        #ifdef __SSE2__
        #include <emmintrin.h>
        #else
        #define SIMDE_ENABLE_NATIVE_ALIASES
        #include <simde/x86/sse2.h>
        #endif
      EOS
    end

    # Upstream's CMake minimum predates CMake 4, which no longer supports it.
    # Reported upstream in choishingwan/PRSice#380.
    system "cmake", "-S", ".", "-B", "build",
                    "-DCMAKE_POLICY_VERSION_MINIMUM=3.5",
                    *std_cmake_args
    system "cmake", "--build", "build"
    bin.install "bin/PRSice"
    pkgshare.install "PRSice.R"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/PRSice --version 2>&1")

    samples = 200
    snps = 40
    causal = 10
    rng = Random.new(42)

    # Genotypes as copies of A1, with the causal variants driving the phenotype.
    genotypes = Array.new(snps) { Array.new(samples) { rng.rand(3) } }
    phenotypes = Array.new(samples) do |i|
      (0...causal).sum { |s| genotypes[s][i] * 0.4 } + (rng.rand * 2.0)
    end

    (testpath/"target.fam").write(Array.new(samples) do |i|
      "FAM#{i} IND#{i} 0 0 1 #{format("%.4f", phenotypes[i])}"
    end.join("\n") + "\n")

    (testpath/"target.bim").write(Array.new(snps) do |s|
      "1\trs#{s + 1}\t0\t#{(s + 1) * 10_000}\tA\tG"
    end.join("\n") + "\n")

    # PLINK 1 binary format: magic bytes, SNP-major, two bits per sample.
    codes = { 2 => 0b00, 1 => 0b10, 0 => 0b11 }
    (testpath/"target.bed").open("wb") do |f|
      f.write [0x6c, 0x1b, 0x01].pack("C*")
      genotypes.each do |snp|
        snp.each_slice(4) do |quad|
          byte = 0
          quad.each_with_index { |g, idx| byte |= codes[g] << (idx * 2) }
          f.write [byte].pack("C")
        end
      end
    end

    (testpath/"base.txt").write("SNP A1 A2 BETA P\n" + Array.new(snps) do |s|
      beta = (s < causal) ? 0.4 : rng.rand * 0.05
      pvalue = (s < causal) ? "1e-8" : 0.5 + (rng.rand * 0.4)
      "rs#{s + 1} A G #{format("%.4f", beta)} #{pvalue}"
    end.join("\n") + "\n")

    system bin/"PRSice", "--base", "base.txt", "--target", "target",
                         "--stat", "BETA", "--beta", "--pvalue", "P",
                         "--binary-target", "F", "--thread", "1",
                         "--out", "result"

    # The best-fit threshold should recover the causal variants and explain
    # most of the phenotypic variance.
    summary = (testpath/"result.summary").read.lines
    assert_match "PRS.R2", summary.first
    fields = summary.last.split("\t")
    assert_equal causal.to_s, fields.last.strip
    assert_operator fields[3].to_f, :>, 0.5

    # One score per sample, plus the header.
    assert_equal samples + 1, (testpath/"result.best").read.lines.count
  end
end
