class Jaq < Formula
  desc "JQ clone focussed on correctness, speed, and simplicity"
  homepage "https://github.com/01mf02/jaq"
  url "https://github.com/01mf02/jaq/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "31e503ad55630c50e34ecc9ed54940986dc06a2fda54e605cc474a36ae5a22b4"
  license "MIT"
  head "https://github.com/01mf02/jaq.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4f51a18fb89fffbbfd9b1870f58f5931d6f3e60299b56141ba6eee51b86fc03b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1033d9a38e8ad7ad885bb2399a382d2a1e0ef1d0e19d325f11fb7439e6f8cc69"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9a82b5a31388c3755b66eb9f3a993eee939196ee18c1edbb44fced79777ddddb"
    sha256 cellar: :any_skip_relocation, sonoma:         "019927c6a3de73451f274dab923e9592fb9d76f89340d5e8036d0da12ab7b281"
    sha256 cellar: :any_skip_relocation, ventura:        "0d0df5adb241c81e10a5584778a622612854abb63596a0543e54074913b4e044"
    sha256 cellar: :any_skip_relocation, monterey:       "c5adc0df1d84fbf3bbf6d4615cd6b4a3c642880fa4b32a0e6d7c5143b8da5710"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bd2f8c3aaa35233eff3edd9fcd2ae719a5210e1c5f884de64d4d24f1570bd1fe"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "jaq")
  end

  test do
    assert_match "1", shell_output("echo '{\"a\": 1, \"b\": 2}' | #{bin}/jaq '.a'")
    assert_match "2.5", shell_output("echo '1 2 3 4' | #{bin}/jaq -s 'add / length'")
  end
end
