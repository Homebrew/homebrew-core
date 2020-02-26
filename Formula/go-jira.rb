class GoJira < Formula
  desc "Simple jira command-line client in Go"
  homepage "https://github.com/go-jira/jira"
  url "https://github.com/go-jira/jira/archive/v1.0.23.tar.gz"
  sha256 "01c86d3119d050774caa41b89fb4f038026542eb1e362e89f3f89bf330b68354"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "38d03e0f3994736458739e37eb82ead82320ac58d2665b7a0d506b268f2ea8b5" => :catalina
    sha256 "49d153052dd5e07bbbdf2adba6b52039fd191cbdf5bf2aa3c2b62c4f1bbd23c8" => :mojave
    sha256 "331cd58a151aa348e63093b362e9a036b5348770fa91ab6d2672a5113c33b7d0" => :high_sierra
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
