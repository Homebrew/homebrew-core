class GoJira < Formula
  desc "Simple jira command-line client in Go"
  homepage "https://github.com/Netflix-Skunkworks/go-jira"
  url "https://github.com/Netflix-Skunkworks/go-jira/archive/v1.0.12.tar.gz"
  sha256 "7ce5d6dcc5021f2019b0107c4ad342979d18bb110188b810017b2d94ff384a33"

  bottle do
    cellar :any_skip_relocation
    sha256 "ef68c2bb7f94975de52779639170aa82a3ee5972af954a473f5e37a99afb4447" => :high_sierra
    sha256 "ea8c595380faa34039a9d9d7220c5548a7af0c0cc8a9dede1b4f3a542a15b252" => :sierra
    sha256 "bb058a932373310e0c7d5be1bc703520daae9aec7a7ebdff10dfbb9e03d057ac" => :el_capitan
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
    debug = open(template_dir + "debug")
    assert_equal("{{ . | toJson}}\n", debug.read)
  end
end
