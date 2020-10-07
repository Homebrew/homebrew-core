class GoJira < Formula
  desc "Simple jira command-line client in Go"
  homepage "https://github.com/go-jira/jira"
  url "https://github.com/go-jira/jira/archive/v1.0.27.tar.gz"
  sha256 "c5bcf7b61300b67a8f4e42ab60e462204130c352050e8551b1c23ab2ecafefc7"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "8362c93c0af122bacd0390a1240756b172977af20ad1165b59b95b9b4e0acfad" => :catalina
    sha256 "51724496ecbd240470d031fadb9b85986dff93fdb5ff028bff0524f1df17c83b" => :mojave
    sha256 "23fe226171b1385c9cc3ba3fa37e64c90770737d4bb40586b2130771b37141a0" => :high_sierra
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
