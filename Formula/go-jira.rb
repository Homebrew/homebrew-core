class GoJira < Formula
  desc "Simple jira command-line client in Go"
  homepage "https://github.com/Netflix-Skunkworks/go-jira"
  url "https://github.com/Netflix-Skunkworks/go-jira/archive/v1.0.19.tar.gz"
  sha256 "fd7b3253213bc7b84694d75620f4dc8640f989f8754fccb964e289d005bec819"

  bottle do
    cellar :any_skip_relocation
    sha256 "6297f060b3b9619f317853647131e488c42560bcb9662d0e4698a9e31e806d67" => :high_sierra
    sha256 "f395cc77022f3c6803dfcfcba7618e71175d77f236c821b286a8aec002a67d70" => :sierra
    sha256 "6517c529ea7f56d8b97cbc8f32928b6688a6d8fa1ab881e8ab6c38620162fdd4" => :el_capitan
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
    # not an exhaustive list, see https://github.com/Netflix-Skunkworks/go-jira/blob/4d74554300fa7e5e660cc935a92e89f8b71012ea/jiracli/templates.go#L239
    expected_templates = %w[comment components create edit issuetypes list view worklog debug]

    assert_equal([], expected_templates - files)
    assert_equal("{{ . | toJson}}\n", IO.read("#{template_dir}/debug"))
  end
end
