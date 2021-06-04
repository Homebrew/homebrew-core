class Gau < Formula
  desc "Open Threat Exchange, Wayback Machine, and Common Crawl URL fetcher"
  homepage "https://github.com/lc/gau"
  url "https://github.com/lc/gau/archive/v1.2.0.tar.gz"
  sha256 "fb363fab0d63fc3a46b4a42bcbf71bc817995b9f14523c0f4fce8ba9c0d89ffa"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "a9715612609171ea02e2c249134f24d4135dd9840811f8ec22683163004efbb1"
    sha256 cellar: :any_skip_relocation, big_sur:       "370fe80090847f4a6ada292142b8b5f591b3cdf6d7c69e73a61b5fe93ab26b24"
    sha256 cellar: :any_skip_relocation, catalina:      "5ed0722411249cadab5035cec15abb31700401404ec1faead6f8ba61be569bff"
    sha256 cellar: :any_skip_relocation, mojave:        "b0d9e8d3425c55a20cb3df80644704d280de21949e019ade9ba4fd572a7bf14e"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args
  end

  test do
    output = shell_output("#{bin}/gau -providers wayback brew.sh")
    assert_match %r{https?://brew\.sh(/|:)?.*}, output
  end
end
