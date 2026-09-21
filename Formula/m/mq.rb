class Mq < Formula
  desc "Jq-like command-line tool for markdown processing"
  homepage "https://mqlang.org/"
  url "https://github.com/harehare/mq/archive/refs/tags/v0.8.5.tar.gz"
  sha256 "02e83968f7c63e0b9ae1e225dfeef43bf57bdb3932bd3286467827cebfd679ce"
  license "MIT"
  head "https://github.com/harehare/mq.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "dc4de06056c26b30bff2b8cf3c7797899b3b5065988f9d39e006cf9a966d62e2"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "a1c7de589e51d8cf0734f8dc336af082093528d8f41656fdf6dc100cfc5675fa"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "164aa3ad6f9ab373d4fd1059a2df1d86ed42443cc895c6c2b220bf18f1e810bd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "20c31e2c30818d13cbdf0352ab5190b9868f6b6fbbe880d2392fbfb674fde4bf"
    sha256 cellar: :any,                 arm64_linux:       "d4037f53304a637f95fa438edb887a2a1b8d7003120c2f610a070a9dc1a49902"
    sha256 cellar: :any,                 x86_64_linux:      "c8612eafc0281f2dd1b2b64edf0ec2549d6328c9ab92724522edefff891be346"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/mq-run")
    system "cargo", "install", *std_cargo_args(path: "crates/mq-lsp")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mq --version")

    (testpath/"test.md").write("# Hello World\n\nThis is a test.")
    output = shell_output("#{bin}/mq '.h' #{testpath}/test.md")
    assert_equal "# Hello World\n", output
  end
end
