class GoJira < Formula
  desc "Simple jira command-line client in Go"
  homepage "https://github.com/go-jira/jira"
  url "https://github.com/go-jira/jira/archive/v1.0.27.tar.gz"
  sha256 "c5bcf7b61300b67a8f4e42ab60e462204130c352050e8551b1c23ab2ecafefc7"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e59a1ae3dc441cf2216b2aab847239884fadaa77b78c56b2d005ef2dd37a7519"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b1352079509d72281e76344ebe41a0704b97a0c116151fb7536a2bb6b26d2bf1"
    sha256 cellar: :any_skip_relocation, monterey:       "7e5fd3b74f5866d42899c6fb895c95b72465db1eb6a41be127e644c12cdf0f53"
    sha256 cellar: :any_skip_relocation, big_sur:        "40fd5a4ecfcb1f7a296651f59f28829e760a1ef69f884766b5262abf972663d6"
    sha256 cellar: :any_skip_relocation, catalina:       "82a05966c4af4b6200507909bc37eaef905f96d69d1c790ae655e35741ca058c"
    sha256 cellar: :any_skip_relocation, mojave:         "32dbd901f35e80fce61a466811dfa5261e543bdb15da855973506e1964c21497"
    sha256 cellar: :any_skip_relocation, high_sierra:    "94372ad76c9857929142891482451672c615a03a32ea310ffcc993b89ad889ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6892ea2385e3c1eb948612c8a9c98a14442ccbdb046779fb0948db892112dc74"
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags", "-s -w", "-trimpath", "-o", bin/"jira", "cmd/jira/main.go"
    prefix.install_metafiles
  end

  test do
    system "#{bin}/jira", "export-templates"
    template_dir = testpath/".jira.d/templates/"

    files = Dir.entries(template_dir)
    # not an exhaustive list, see https://github.com/go-jira/jira/blob/4d74554300fa7e5e660cc935a92e89f8b71012ea/jiracli/templates.go#L239
    expected_templates = %w[comment components create edit issuetypes list view worklog debug]

    assert_equal([], expected_templates - files)
    assert_equal("{{ . | toJson}}\n", File.read("#{template_dir}/debug"))
  end
end
