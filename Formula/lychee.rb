class Lychee < Formula
  desc "Fast, async, resource-friendly link checker"
  homepage "https://github.com/lycheeverse/lychee"
  url "https://github.com/lycheeverse/lychee/archive/v0.8.2.tar.gz"
  sha256 "55b83a5d7145afc4358b29db49d8e107494b64bf4f8938da865ffed978d29cda"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/lycheeverse/lychee.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "4f8e4bdda220ced4452fc8ae21011fc0647a9cb0322ed29f99c56c50a7d6b6b2"
    sha256 cellar: :any,                 arm64_big_sur:  "2c476a60bf7e938fd6b4472379d3f5d7f97b0d56fa0d19fcc3a6ab009c0e900c"
    sha256 cellar: :any,                 monterey:       "e6480cfc0804c392afae1f10eb50c800f2cc123a937640624c960bdc25475444"
    sha256 cellar: :any,                 big_sur:        "52f76f1420ee645c2e2d6dce534bd2490a218b2baf6e63a3315b27f065463cc0"
    sha256 cellar: :any,                 catalina:       "7fba25449c3511421633007208668d11f0ae95889daa29c9cb10b86f33903585"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "21a1f246be72c48c702545900a47d47b6f09c0e88db98fce82d26a5416da8b20"
  end

  depends_on "rust" => :build
  depends_on "openssl@1.1"

  on_linux do
    depends_on "pkg-config" => :build
  end

  def install
    cd "lychee-bin" do
      system "cargo", "install", *std_cargo_args
    end
  end

  test do
    (testpath/"test.md").write "[This](https://example.com) is an example.\n"
    output = shell_output(bin/"lychee #{testpath}/test.md")
    assert_match "🔍 1 Total ✅ 1 OK 🚫 0 Errors", output
  end
end
