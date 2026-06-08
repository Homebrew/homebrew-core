class Nuls < Formula
  desc "NuShell-inspired ls with colorful table output"
  homepage "https://github.com/cesarferreira/nuls"
  url "https://static.crates.io/crates/nuls/nuls-0.2.0.crate"
  sha256 "24fb69fbb3ca465f6e051d36c75867f9fbe3e358eedb931fcb65125e4946e08e"
  license "MIT"
  head "https://github.com/cesarferreira/nuls.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f7853c7edb37e8f6b2ab6be53cfbbec8792b5409a5bf53410c9c433e44c3b5d9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a546a2f26209f0c99229704546a213beb1a75fa4153511a5e4c483663182594c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "182193b2c05adf014410c219841452098a2004bad137a4486c76fd7b6ec903b5"
    sha256 cellar: :any_skip_relocation, sonoma:        "4366a0bfa20f47c5136addc8b7032a5396b7dd3f83fe11d07481fb7383e6f290"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "29699df43f434e49dfeb6005b083d7880f9a98e46a31573948e0a53760b10f3a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "972b23b9057637b27f2aa198fe3e4938a94d8d0ed3ee32660e2b0bea8c63a0e2"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"foo.txt").write "hello\n"

    assert_match version.to_s, shell_output("#{bin}/nuls --version")
    assert_match "foo.txt", shell_output("#{bin}/nuls #{testpath}")
  end
end
