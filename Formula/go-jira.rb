class GoJira < Formula
  desc "Simple jira command-line client in Go"
  homepage "https://github.com/go-jira/jira"
  url "https://github.com/go-jira/jira/archive/v1.0.26.tar.gz"
  sha256 "306e58e5affa231e84b35ff965b3c359adb4bc853054b3bde9f80b8f07cee80b"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "19d9cfa31f0f5de1484fab9fd3f2886395801a4e260a58511c2cce5619e422b9" => :catalina
    sha256 "90274a3a760f9f7757c3b5bf58bf7f08fb43b91b134a4d6dc615c1910af18353" => :mojave
    sha256 "a7e745cca1d91fd57a189223858c841bfa362eb557f63b8c892aa6e4c2b7e5d9" => :high_sierra
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
