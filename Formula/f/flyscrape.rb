class Flyscrape < Formula
  desc "Standalone and scriptable web scraper"
  homepage "https://flyscrape.com/"
  url "https://github.com/philippta/flyscrape/archive/refs/tags/v0.9.0.tar.gz"
  sha256 "cbc8c977c55f9617ce29f2178c00c22bda4bd9d1987f37c688580c2848653e17"
  license "MPL-2.0"
  head "https://github.com/philippta/flyscrape.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "34de5d209bcfcfb510bc9ec43a81755488495268e1a77f1a1adfff55a3e1888a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "acb2f440ac077232c69c85695e4881e8d3b55d6e4ea479692bb7d27843425bff"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "eedd58ef7911aa33feacab98dbe7c71882d9113238b5fb8cf81683b9cc01cbc3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2b50a2604f78102cdb89c054e6843dd1972bf6b96a3849297dc5cd2923b02114"
    sha256 cellar: :any_skip_relocation, sonoma:        "f4deece613d812a4224b21a3688f741009372a80bd1a0f18190dae3e29672f85"
    sha256 cellar: :any_skip_relocation, ventura:       "1f804a2b20deb93cca4a66cb987b8d1a65c121eb0e80b1a29afa662814298898"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0f2ca5e824cb609b0595fe8cb1801db26c31419ba8adfe8eec6e409b66726f7a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0b0a8620570646d6112ef6424c5cb7463c860e6e1a045662fef70d50fb6b6977"
  end

  depends_on "go" => :build

  uses_from_macos "sqlite"

  def install
    tags = "osusergo,netgo,sqlite_omit_load_extension"
    system "go", "build", *std_go_args(ldflags: "-s -w", tags:), "./cmd/flyscrape"

    pkgshare.install "examples"
  end

  test do
    test_config = pkgshare/"examples/hackernews.js"
    return_status = OS.mac? ? 1 : 0
    output = shell_output("#{bin}/flyscrape run #{test_config} 2>&1", return_status)
    expected = if OS.mac?
      "failed to create database file"
    else
      "\"url\": \"https://news.ycombinator.com/\""
    end
    assert_match expected, output
  end
end
