class Difftastic < Formula
  desc "Diff that understands syntax"
  homepage "https://github.com/Wilfred/difftastic"
  url "https://github.com/Wilfred/difftastic/archive/refs/tags/0.69.0.tar.gz"
  sha256 "49d722fb80a0324ea99fe11907f796cde635443084d15cc6f1afd9e0de54bde0"
  license "MIT"
  compatibility_version 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "adeee07ce46a80120703fff697a0e5605369fafe2471fba03695d1f00d559f85"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c30f2557cce858c5d544a2beea3634c52e0ed757801788bd8bf4a394e8456f9a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fd335a368bb5c5c0eb0ebf007e0accf4ca1909059d185fc445578b59c1a78975"
    sha256 cellar: :any_skip_relocation, sonoma:        "2c63479af1f90032d42ccdd0debd30a3be754e0b5a738f64be9b35b4caba9d19"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "083e87cec3760db3c164b0943fbcb36bced58d4c550b604143de156f82c13755"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4cbd6f8a73c728170b2db8c334f919154560411962ae78cc0ff52f1187e7951d"
  end

  depends_on "rust" => :build

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
