class Delly < Formula
  desc "Structural variant discovery by paired-end and split-read analysis"
  homepage "https://github.com/dellytools/delly"
  url "https://github.com/dellytools/delly/archive/refs/tags/v2.3.1.tar.gz"
  sha256 "4e2568b16039d40399f58e7cffc851bfdb17ae5eccbc0c2e1768502c0895e42e"
  license "BSD-3-Clause"
  head "https://github.com/dellytools/delly.git", branch: "main"

  depends_on "boost"
  depends_on "htslib"
  depends_on "xz"

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  def install
    system "make", "src/delly",
           "HTSLIBINCDIR=#{formula_opt_include("htslib")}",
           "HTSLIBLIBDIR=#{formula_opt_lib("htslib")}",
           "BOOSTINCDIR=#{formula_opt_include("boost")}",
           "BOOSTLIBDIR=#{formula_opt_lib("boost")}"
    bin.install "src/delly"
    prefix.install %w[example R scripts]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/delly --version 2>&1")
    system bin/"delly", "lr", "-g", prefix/"example/ref.fa", "-o", testpath/"lr.bcf", prefix/"example/lr.bam"
    assert_path_exists testpath/"lr.bcf"
  end
end
