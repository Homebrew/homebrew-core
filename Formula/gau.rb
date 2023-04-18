class Gau < Formula
  desc "Open Threat Exchange, Wayback Machine, and Common Crawl URL fetcher"
  homepage "https://github.com/lc/gau"
  url "https://github.com/lc/gau/archive/v2.1.2.tar.gz"
  sha256 "2900ba86dfda01b5d8a90e1547f158feb134f6d2b757ff8fc77d96d290f72e4c"
  license "MIT"
  head "https://github.com/lc/gau.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ff3c4dfa76c55fb3d9f4aca25dd7311e32a8cf68c3eef0a59730ba93b01242d0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "69fa3291ac27be667e85c304dc09bb66375c51baeb5fcee0611a370aa0880c0b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2c6825916653f661d5a7ef5179185d2d68315c8bd08a34b0c788abbf05574e2e"
    sha256 cellar: :any_skip_relocation, ventura:        "6b083901d3caa8436d86a3ab6dccd8a158a096c3ba661ae5b0793b0a12b4d26f"
    sha256 cellar: :any_skip_relocation, monterey:       "fbfb406d2af502acf270b0907466ae1c8a94172ef8e22c87f5bdb3b7ca6f1cec"
    sha256 cellar: :any_skip_relocation, big_sur:        "f27a77b5321b456b1fb37e7ec396a5fa449e7f26938804f68d378dce8cef196a"
    sha256 cellar: :any_skip_relocation, catalina:       "461ac21a199fa8435f68129edc6c9cb3f52d716026a373e978adcf4a0d52c533"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2673a688e06d00163439668c054944ab1965078c36be3dac11fa000dd8a2a888"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/gau"
  end

  test do
    output = shell_output("#{bin}/gau --providers wayback brew.sh")
    assert_match %r{https?://brew\.sh(/|:)?.*}, output
  end
end
