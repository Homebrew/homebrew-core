class GoJira < Formula
  desc "Simple jira command-line client in Go"
  homepage "https://github.com/go-jira/jira"
  url "https://github.com/go-jira/jira/archive/v1.0.21.tar.gz"
  sha256 "c76089423fc0d4b9dcdd39822d6d94452136f8f24b8c17ec75b0e702e40fbcc2"

  bottle do
    cellar :any_skip_relocation
    sha256 "470f7105708b78919c14f33a052ddb9224ed9a6e518771b656fbee408fe860ae" => :mojave
    sha256 "dec791b7060932024a39da7f30830215db75594dc0626dba4807bcf4baa77680" => :high_sierra
    sha256 "d3cd28544ccbd2e413e504b801e19107d7a3c009a51b65578af6c8b15b0ff44b" => :sierra
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
