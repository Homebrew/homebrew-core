class Difftastic < Formula
  desc "Diff that understands syntax"
  homepage "https://difftastic.wilfred.me.uk/"
  url "https://github.com/Wilfred/difftastic/archive/refs/tags/0.71.0.tar.gz"
  sha256 "d6afd26103c6492a91307dc6779c7dd0ca4d4c85499f81d7dc53fdfa5107331d"
  license "MIT"
  compatibility_version 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "5578ee6094135d736ede1dd69a6017aad8ac8d63dc3ee0e0227e5a2fdd564a7c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c7f055b257d9555a8f43c79df32518dc4f23e68a6294a53418c0915bdebfe2e0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "3a87d1b22ad38660211129051f6a3a33fa05528e26a1b4d80f9f7f5c7b41ad7f"
    sha256 cellar: :any,                 arm64_linux:       "02cb64d0d56cf55db18d6ae838432b1bfa44552968682c1df8623b40d571a5ff"
    sha256 cellar: :any,                 x86_64_linux:      "2af99f057a86b205a04c4c590ce481a3d22fa60aab4a1f388debc2bbf3c6cf7c"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", "--locked", "--target", "host-tuple"
  end

  def install
    system "cargo", "install", *std_cargo_args
    man1.install "difft.1"
  end

  test do
    (testpath/"a.py").write("print(42)\n")
    (testpath/"b.py").write("print(43)\n")
    expected = <<~EOS
      b.py --- Python
      1 print(42)                  1 print(43)\n
    EOS
    assert_equal expected, shell_output("#{bin}/difft --color never --width 80 a.py b.py")
  end
end
