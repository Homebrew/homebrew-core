class Gau < Formula
  desc "Open Threat Exchange, Wayback Machine, and Common Crawl URL fetcher"
  homepage "https://github.com/lc/gau"
  url "https://github.com/lc/gau/archive/refs/tags/v2.2.3.tar.gz"
  sha256 "02bb84bd73a385b4630a6c783f819f8339defc915df3a7d34cb872801d567c17"
  license "MIT"
  head "https://github.com/lc/gau.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "6a7a73185ebc04985bb28d9f8a6dd8adc45c86251bdea0e2be8cf1546208c817"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6e7e174f9d51ebd025df50bc9a448fb343a594a3dbce12c3a5d92d764ede2e7e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "682fc4cbe81d9688fb80a492df88e0d9f9c17101b4e1eeac885f12e9bd1908f2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bac525cf8acad4a9504e89f4ada800d733a5cfc9d0449c0ddd1c9a412442d3cf"
    sha256 cellar: :any_skip_relocation, sonoma:         "1dd162ff7bd93c4ae710f7c655abdb2a6b67016d76199e208f13db2913bde9a3"
    sha256 cellar: :any_skip_relocation, ventura:        "b4cedea7ef90ce255971d618bc3bc7f5dba2a116bb4f74b7d0f7ac09426e12fa"
    sha256 cellar: :any_skip_relocation, monterey:       "12d4f69ada8cc5716190b1d1444f57a225af5ed9c67ea4945c3ef73cbb21dcc3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "753998790d9fdd227c1a824b62d612ab7eefe3a46422b929c5fbe39b7c8d2310"
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
