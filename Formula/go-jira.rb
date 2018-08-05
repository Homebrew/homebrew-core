class GoJira < Formula
  desc "Simple jira command-line client in Go"
  homepage "https://github.com/Netflix-Skunkworks/go-jira"
  url "https://github.com/Netflix-Skunkworks/go-jira/archive/v1.0.20.tar.gz"
  sha256 "0adf6d68e4a0700578706d9707dab633db8ee336151ce4232de93c7332459c45"

  bottle do
    cellar :any_skip_relocation
    sha256 "f87b7d4a48ba0989c19625067dbbc06cb65e76242e71e7fb1d672c6e54023d31" => :high_sierra
    sha256 "6782e2ae39d1921c16bf4e2863d18e8e96d04323b512ec9679e121084e67f153" => :sierra
    sha256 "8c67b5ca36133cf48e20e1f9f1c089337e1c936fa586e5d9146e6de35bf1abb2" => :el_capitan
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
