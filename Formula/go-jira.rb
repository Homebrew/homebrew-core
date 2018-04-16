class GoJira < Formula
  desc "Simple jira command-line client in Go"
  homepage "https://github.com/Netflix-Skunkworks/go-jira"
  url "https://github.com/Netflix-Skunkworks/go-jira/archive/v1.0.17.tar.gz"
  sha256 "c1127af5ff8d19ab3f6b5bf424f262495143448608ec59beadcefb5e645feddb"

  bottle do
    cellar :any_skip_relocation
    sha256 "222f4cebde8b610bf11e95296560a638e63c10f4d98e62e8d97db1eeea4a6bd1" => :high_sierra
    sha256 "7d7ae92cfd19ad9232d4d925ba9981e00ea38fc47c84274a5371d970355a1079" => :sierra
    sha256 "bd66cb22f874fbb7fd1e8fdfbc3c0515e94b36638dc7a5a69a0629b4864e21bb" => :el_capitan
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
