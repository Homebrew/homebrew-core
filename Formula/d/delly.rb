class Delly < Formula
  desc "Structural variant discovery by paired-end and split-read analysis"
  homepage "https://github.com/dellytools/delly"
  url "https://github.com/dellytools/delly/archive/refs/tags/v2.8.1.tar.gz"
  sha256 "09cfe5e6678ddd9da8b21667c0a593ad3c4dcac55bccfb04d068cebfc252f425"
  license "BSD-3-Clause"
  head "https://github.com/dellytools/delly.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "b852cc85193c35776db60aed6cadc00a026ffab6a9dceaea7a867b2ba61fe5ab"
    sha256 cellar: :any, arm64_tahoe:       "34f240137f16396aa0491ae7d5cce6843d748c7c1eb5bc45de683c4ac1297b73"
    sha256 cellar: :any, arm64_sequoia:     "ff96a3795c177c8781e31a20293e4732b49557955087b14eaf19f31997fcde68"
    sha256 cellar: :any, arm64_linux:       "4121f97d23c44652df3a07a3fbe190f30f57ba0bdb237f223fdad1f755ae796f"
    sha256 cellar: :any, x86_64_linux:      "4ce12c879a169d040b8459b673873c300cd18d7d69f7f644ac107b7b70ea763c"
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
