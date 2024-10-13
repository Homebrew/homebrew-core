class Grex < Formula
  desc "Command-line tool for generating regular expressions"
  homepage "https://github.com/pemistahl/grex"
  url "https://github.com/pemistahl/grex/archive/refs/tags/v1.4.5.tar.gz"
  sha256 "4e849b29b387afc583856f24923b76052ad90e320c2caacfc6452e6d9deb6b14"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "62f1c138b89ba5eb7905c9a69a0e603fb08a15fe2581179e68a1b44cc1653e55"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "648f037498a0a75daa32f8f66205a4f8ee106f1da3cfb1169d973ed786dbdb3c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1b67b1b26968582e6383cf09cc0f31e3d5a62d8a2c45b5246609114ed85762e5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5fe8bf956fb843e7a907aedf0e4525361f8808c5797e946f6c3272410aa65f19"
    sha256 cellar: :any_skip_relocation, sonoma:         "fd8802c295d2ee244d77c7c35142d51ead796828fb53c10fcf7b251b96ceb6c0"
    sha256 cellar: :any_skip_relocation, ventura:        "0528090df6c47ec9fd13cf0ad1933192355eebd3417448d2196a132b79217ed7"
    sha256 cellar: :any_skip_relocation, monterey:       "f923d61f66b321320d28e8aa836af2509336a970b28dd445290b2b1987772f9b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "48acaaa4f1f139f5d932f7a76dcab8c1bdbf96dbe0db59175c2e453c04ca8e34"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    output = shell_output("#{bin}/grex a b c")
    assert_match "^[a-c]$\n", output
  end
end
