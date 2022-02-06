class Findomain < Formula
  desc "Cross-platform subdomain enumerator"
  homepage "https://github.com/Findomain/Findomain"
  url "https://github.com/Findomain/Findomain/archive/6.0.0.tar.gz"
  sha256 "9db0f8bb7386930a8642c877eafe1b23da29487cfa7b19a222a402d3c70fe349"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4339bc0c281c0b64e490fd1e38f67a09418926753a30673a60430e0527cca5a0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2d584f9de7dcbf54709e5e90474fa6ee3f58fdf7c802fcf0eec4c5fd7aa91793"
    sha256 cellar: :any_skip_relocation, monterey:       "2e408b8ecbe9b156a17ce1de7a80fe07b1d3e305d6b79a1e02852eb1605f6b33"
    sha256 cellar: :any_skip_relocation, big_sur:        "9a5859739f8f45a00d5d1347630c7939148face0053fcc163303688774999ad6"
    sha256 cellar: :any_skip_relocation, catalina:       "df19a09cb240ce86e503778c31b21360e504d0ddc5b23d377e199025a5a03edf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "004f8d6e0209254f708f87642374653c3c78dbf943927b94cfeed5554f858f6d"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "Good luck Hax0r", shell_output("#{bin}/findomain -t brew.sh")
  end
end
