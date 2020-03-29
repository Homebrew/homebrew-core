class GoJira < Formula
  desc "Simple jira command-line client in Go"
  homepage "https://github.com/go-jira/jira"
  url "https://github.com/go-jira/jira/archive/v1.0.23.tar.gz"
  sha256 "01c86d3119d050774caa41b89fb4f038026542eb1e362e89f3f89bf330b68354"

  bottle do
    cellar :any_skip_relocation
    sha256 "77a16e13c81b90fb7a7cb90ce607531b1bb932a31e2db1aedfdb6d85d7986f1d" => :catalina
    sha256 "f165d25aa98ec17d4da66fa9c3b727c1b99723043ad4b259f01b6aa3e8c80bfd" => :mojave
    sha256 "a4d50f8c0376b0bef991ee3d7e9c50621dfae151e9bdb0e5ed143649de49a283" => :high_sierra
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
