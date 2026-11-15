class Difftastic < Formula
  desc "Diff that understands syntax"
  homepage "https://difftastic.wilfred.me.uk/"
  url "https://github.com/Wilfred/difftastic/archive/refs/tags/0.72.0.tar.gz"
  sha256 "ed8e2d59d44d62289b17c9d241e469bd72565fadf13c260676fc7a23bc28a844"
  license "MIT"
  compatibility_version 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "723b703f2dd8d40a55b8d25b4281d03910afeadc999e894564e10325629b601e"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "9693c05f15d218cac89059bf485fb18184042794d6b11970c285b1baa18ccbc7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "ee1042381b293f2e1f013399651970efa781d06830238df8b01f3a63ff8dd2d1"
    sha256 cellar: :any,                 arm64_linux:       "37022c7048f3db689bc71ee0f47e286da757c390cbb9cb336e017345cfc5229f"
    sha256 cellar: :any,                 x86_64_linux:      "198745b464c6af1e417e5ae3eb30152792980593a396e5ae36fc1eb156188ede"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
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
