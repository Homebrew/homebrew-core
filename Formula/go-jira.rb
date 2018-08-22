class GoJira < Formula
  desc "Simple jira command-line client in Go"
  homepage "https://github.com/Netflix-Skunkworks/go-jira"
  url "https://github.com/Netflix-Skunkworks/go-jira/archive/v1.0.20.tar.gz"
  sha256 "0adf6d68e4a0700578706d9707dab633db8ee336151ce4232de93c7332459c45"

  bottle do
    cellar :any_skip_relocation
    sha256 "69723da9114c344a1a2347e4a7322f775f06d91c0ab0ad316d74ca98af5dfda5" => :mojave
    sha256 "d67b73a521d6099a9678bd7a71e4a674aa8716ab8a5ee144f59c291c8407b07a" => :high_sierra
    sha256 "37cb5ab6baf5c50021065867e8a987bff114b304d6b367eed68e1fa4be1274e1" => :sierra
    sha256 "bac5dd48d79e57e1df1da2b42924d55d2bdd474c9ed08898259cfa180d8e2d23" => :el_capitan
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
