class GoJira < Formula
  desc "Simple jira command-line client in Go"
  homepage "https://github.com/Netflix-Skunkworks/go-jira"
  url "https://github.com/Netflix-Skunkworks/go-jira/archive/v1.0.15.tar.gz"
  sha256 "c1690928cec39799f796a47bd81fc0db9404a332caf7bb0ef6847adc91ee42b8"

  bottle do
    cellar :any_skip_relocation
    sha256 "146cdcca1cfcf0c950fea209100769aa9832bee22c924cb21f8da1e13433b1f1" => :high_sierra
    sha256 "f5710f28a79317fcbe98eb3bb6674e78d957811e4517266b09dd3375915dc03f" => :sierra
    sha256 "3c97af966b4ef4dd2ef1df1f7982120785ecc2ab5b3b58148b2913a0de7e5ad1" => :el_capitan
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
