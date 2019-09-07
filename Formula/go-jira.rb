class GoJira < Formula
  desc "Simple jira command-line client in Go"
  homepage "https://github.com/go-jira/jira"
  url "https://github.com/go-jira/jira/archive/v1.0.20.tar.gz"
  sha256 "50425c5c19d0eddbaf9b8b76f17942f79880f2df311c0786011d85eb21b7765a"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "41844ed2685625a985d3efcafca1afcd62ee5216211a1e03406b43e6aeb2475e" => :mojave
    sha256 "d61509862936244938ccf77ac0b9ae1c572a49535bf4da449f82d63b971381d3" => :high_sierra
    sha256 "59b86defc9c4dcc6bb722956365e52409f18c4a4a392d2e668a33a51a931a70c" => :sierra
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
