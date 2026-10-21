class Delly < Formula
  desc "Structural variant discovery by paired-end and split-read analysis"
  homepage "https://github.com/dellytools/delly"
  url "https://github.com/dellytools/delly/archive/refs/tags/v2.7.0.tar.gz"
  sha256 "e0965d4a6f9f5336f7697049d40b6621fa0946dcc1747ff93cee1abfdb842e20"
  license "BSD-3-Clause"
  head "https://github.com/dellytools/delly.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "d766921909f3effeff3e66298ef947a1f4e56cc02f84d367e83e50dfa0a4fd53"
    sha256 cellar: :any, arm64_tahoe:       "babbbcc264d24766f1e3d11351677fcbb6126eb442f76f0d0e04046c9265d24c"
    sha256 cellar: :any, arm64_sequoia:     "87c5f97973e566e8c9c0b5021e54fee0b6c8f8bc9fc43113fb21fb69471c0b3e"
    sha256 cellar: :any, arm64_linux:       "d94a7de7a48a344f029b9cae449c6194c986ab9759442e6bc391efb0124768f4"
    sha256 cellar: :any, x86_64_linux:      "2da09f886505dfb7a7594a38bc64d7947b2295e7edcb3eff480aad64daa52a8a"
  end

  depends_on "boost"
  depends_on "htslib"
  depends_on "xz"

  uses_from_macos "bzip2"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "make", "src/delly",
           "HTSLIBINCDIR=#{formula_opt_include("htslib")}",
           "HTSLIBLIBDIR=#{formula_opt_lib("htslib")}",
           "BOOSTINCDIR=#{formula_opt_include("boost")}",
           "BOOSTLIBDIR=#{formula_opt_lib("boost")}"
    bin.install "src/delly"
    pkgshare.install %w[example R scripts]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/delly --version 2>&1")
    system bin/"delly", "lr", "-g", pkgshare/"example/ref.fa", "-o", testpath/"lr.bcf", pkgshare/"example/lr.bam"
    assert_path_exists testpath/"lr.bcf"
  end
end
