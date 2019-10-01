class GoJira < Formula
  desc "Simple jira command-line client in Go"
  homepage "https://github.com/go-jira/jira"
  url "https://github.com/go-jira/jira/archive/v1.0.22.tar.gz"
  sha256 "428099801521debb46f30ed602481e92c4560e2251542c1f1a2dc4a818ff9765"

  bottle do
    cellar :any_skip_relocation
    sha256 "562a0922313a626d983c8150a8527c42c933f9d21ac587bdf81f90f558228ad4" => :catalina
    sha256 "bc1ceb2829539132828c91393d925481ea32fad23acd812caeded39245c4c7bc" => :mojave
    sha256 "5dacf7ae9a20486722af587660682bada1acfd8e443e4ff7e67918afe6f33b39" => :high_sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    dir = buildpath/"src/gopkg.in/Netflix-Skunkworks/go-jira.v1"
    dir.install buildpath.children

    cd dir do
      system "go", "build", "-o", bin/"jira", "-ldflags", "-w -s", "cmd/jira/main.go"
      prefix.install_metafiles
    end
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
