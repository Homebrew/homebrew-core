class GoJira < Formula
  desc "Simple jira command-line client in Go"
  homepage "https://github.com/go-jira/jira"
  url "https://github.com/go-jira/jira/archive/v1.0.27.tar.gz"
  sha256 "c5bcf7b61300b67a8f4e42ab60e462204130c352050e8551b1c23ab2ecafefc7"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "40fd5a4ecfcb1f7a296651f59f28829e760a1ef69f884766b5262abf972663d6" => :big_sur
    sha256 "b1352079509d72281e76344ebe41a0704b97a0c116151fb7536a2bb6b26d2bf1" => :arm64_big_sur
    sha256 "82a05966c4af4b6200507909bc37eaef905f96d69d1c790ae655e35741ca058c" => :catalina
    sha256 "32dbd901f35e80fce61a466811dfa5261e543bdb15da855973506e1964c21497" => :mojave
    sha256 "94372ad76c9857929142891482451672c615a03a32ea310ffcc993b89ad889ff" => :high_sierra
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
    assert_equal("{{ . | toJson}}\n", IO.read("#{template_dir}/debug"))
  end
end
