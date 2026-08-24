class Difftastic < Formula
  desc "Diff that understands syntax"
  homepage "https://difftastic.wilfred.me.uk/"
  url "https://github.com/Wilfred/difftastic/archive/refs/tags/0.70.0.tar.gz"
  sha256 "4f89fdce7f58eb0521c14c14a7f76144dab5aa01400b332dd8710b550d32dc4c"
  license "MIT"
  compatibility_version 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ad1ca4686d476b7b6783c03b052cd73cc3edd97f9172c14c89415a4a8a3de2dc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f9f3d560214fb3f4277953bab812a0c8ad3ea699dc8a1aa347c8910e78af8664"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3dcfdc526d9aefd9eff45f6dd8045634ab2f0eceaa9dcd84aacb655030a87c1a"
    sha256 cellar: :any_skip_relocation, sonoma:        "a61e10e46ce5797caf1b66f62594803d45f853a0c9a5c1dbe26c9e979b549b11"
    sha256 cellar: :any,                 arm64_linux:   "8bbd7298a69e44335666033f15bef61fcbc7f2cef6b4d7152b1d3535475b3012"
    sha256 cellar: :any,                 x86_64_linux:  "3b80591fc994c67efa94403f93451e13deb8737af999f636ec05f3ca52e1c5aa"
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
