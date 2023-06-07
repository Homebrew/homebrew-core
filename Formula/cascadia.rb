class Cascadia < Formula
  desc "Go cascadia package command-line CSS selector"
  homepage "https://github.com/suntong/cascadia"
  url "https://github.com/suntong/cascadia/archive/refs/tags/v1.2.7.tar.gz"
  sha256 "ff314144fdab70a7347b0c1a27b5e6628abe72827947e3cb571cebd385fd61df"
  license "MIT"
  head "https://github.com/suntong/cascadia.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "65b90030a149ed44e56fc8399fceaa7d3307dce4951018d203fec522722b5c8a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "915e11269b0658517c806deb79646119a53124136ff45954504a3ea8b93fa5e8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "75868779193019bef18dfc7659c8df745178ca4719305f5a009cd289c28e2e35"
    sha256 cellar: :any_skip_relocation, ventura:        "cdc7271290c034162eeac51ac56bc5b7482b6d3c4cb027008278c7ebbedde79e"
    sha256 cellar: :any_skip_relocation, monterey:       "9f9f51c6bf2fe1c811d60e3cd1471bf640bd6d80cea974c5ffde79fe0533effc"
    sha256 cellar: :any_skip_relocation, big_sur:        "f26cf2962f52d9c4d298cb50d1f2031fa13aa803636d68266a5c605b646e2026"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "50c45d03b556eda022221bf2d139f8a0bae38cc7805a9f5ded46f196d1641b95"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match "Version #{version}", shell_output("#{bin}/cascadia --help")

    test_html = "<foo><bar>aaa</bar><baz>bbb</baz></foo>"
    test_css_selector = "foo > bar"
    expected_html_output = "<bar>aaa</bar>"
    assert_equal expected_html_output,
      pipe_output("#{bin}/cascadia --in --out --css '#{test_css_selector}'", test_html).strip
  end
end
