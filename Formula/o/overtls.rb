class Overtls < Formula
  desc "Simple proxy tunnel for bypassing the GFW"
  homepage "https://github.com/ShadowsocksR-Live/overtls"
  url "https://github.com/ShadowsocksR-Live/overtls/archive/refs/tags/v0.2.29.tar.gz"
  sha256 "1211aecc670ae59deee6a7336da5ac7dadb2abb833ae538fe4921149c9fb2fa1"
  license "MIT"
  head "https://github.com/ShadowsocksR-Live/overtls.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2469d42ce13b84ac793ac4e52bc5e91715d940119026a8eefba4182dcfe0099b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "48833f3fd2f73a8f8f3df2ac74d1560f1812344a7b0252efb01cd10b2052faf0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "50e97fc4858ac99aebf5ed1ab46e36bf33bf851098fc7b80197d0f417615eada"
    sha256 cellar: :any_skip_relocation, sonoma:         "a83720b031ae63d610020ef6fe0616a5078c01163c42181a23ba506242cefa5d"
    sha256 cellar: :any_skip_relocation, ventura:        "d6cf0a130bf5fd7546955f99d3ec1b35c61bf0279e4302e9ed861e641261e791"
    sha256 cellar: :any_skip_relocation, monterey:       "e5994dc0b4f886edb360c6628747c680d35d39a6c118c1f2b674ef9ebde3669f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f03a052b4598d114be674f1527b8a58d9ba87d3354f73f6cd9b753ab78c53a6f"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    pkgshare.install "config.json"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/overtls -V")

    output = shell_output(bin/"overtls -r client -c #{pkgshare}/config.json 2>&1", 1)
    assert_match "Error: Io(Kind(TimedOut))", output
  end
end
