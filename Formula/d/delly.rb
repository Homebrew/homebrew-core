class Delly < Formula
  desc "Structural variant discovery by paired-end and split-read analysis"
  homepage "https://github.com/dellytools/delly"
  url "https://github.com/dellytools/delly/archive/refs/tags/v2.8.2.tar.gz"
  sha256 "9c870926df96772cca1f784aa3e92adfb2b0f510734f1c05fb197045077150e1"
  license "BSD-3-Clause"
  head "https://github.com/dellytools/delly.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "03846319b71b923de2ee7ab7b27235ee05a7c457c65fd8ad6184bc5f5087ca45"
    sha256 cellar: :any, arm64_tahoe:       "96d2b9c398cb8545a349e98de0b38dfc3069b8af9413476982380f7c38962db0"
    sha256 cellar: :any, arm64_sequoia:     "b81c231f05132b575eea46d5e2a39d2776632b0a664ce70391eae433bba5e667"
    sha256 cellar: :any, arm64_linux:       "669ffac049cf677e14b01af8290878482c45a3bf187600e392ccffd713ceb08f"
    sha256 cellar: :any, x86_64_linux:      "beacc8b71ad7070d1e90a74f3d73dccca9a7a841612dae5b80e63a094b2e4300"
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
