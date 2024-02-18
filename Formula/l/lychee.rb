class Lychee < Formula
  desc "Fast, async, resource-friendly link checker"
  homepage "https://github.com/lycheeverse/lychee"
  url "https://github.com/lycheeverse/lychee/archive/refs/tags/v0.14.3.tar.gz"
  sha256 "b2ce1bd57040ab9d1719b9540e8c2905327f6a71674a0e5f2297f00bb4410651"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/lycheeverse/lychee.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "8add17c02ea36a4a2baefe80f8d343a0fd8eb1ddf8f8358b8b50d6a171dab145"
    sha256 cellar: :any,                 arm64_ventura:  "e2b0467a22f97a8524f1fa800c88baaa946c7636d4be805be54d2ed86a68c54c"
    sha256 cellar: :any,                 arm64_monterey: "bfde51ee50cc21f50de35015c8b5e33556691b4d9c56bfc9419905475d51dc05"
    sha256 cellar: :any,                 sonoma:         "1ee613a63ddddbe842cd43ebb9268c91dde6689e2666478fa3892911d5c5cdfd"
    sha256 cellar: :any,                 ventura:        "af75dd5f3a93e7a94ecd69a1c4bcf486fe6fc171f626d9af68c9662af3d7c8ca"
    sha256 cellar: :any,                 monterey:       "017ab64c9e0662cf2438ef588decf115648be6d37eb85a39f0bc717e622421d6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "504469b40e0be7cd5ee31c3d38870af58298bd931f6d3a4ffd0dc0bda1db418c"
  end

  depends_on "rust" => :build
  depends_on "openssl@3"

  on_linux do
    depends_on "pkg-config" => :build
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "lychee-bin")
  end

  test do
    (testpath/"test.md").write "[This](https://example.com) is an example.\n"
    output = shell_output(bin/"lychee #{testpath}/test.md")
    assert_match "✅ 0 OK 🚫 0 Errors 💤 1 Excluded", output
  end
end
