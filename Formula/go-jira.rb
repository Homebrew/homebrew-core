class GoJira < Formula
  desc "Simple jira command-line client in Go"
  homepage "https://github.com/Netflix-Skunkworks/go-jira"
  url "https://github.com/Netflix-Skunkworks/go-jira/archive/v1.0.15.tar.gz"
  sha256 "c1690928cec39799f796a47bd81fc0db9404a332caf7bb0ef6847adc91ee42b8"

  bottle do
    cellar :any_skip_relocation
    sha256 "61522beee9effbaa76b9cd9e21f787744959a7c32702a880e5204bd9f38b25ad" => :high_sierra
    sha256 "fa2537f1f352df8f3fcdc4ce4e586a4b8758643adb473ee45fb778cc0773830f" => :sierra
    sha256 "1490b3bff3b70e5752ec518897af1184d2371fc2e8c1ddc3525ecace1431a5ae" => :el_capitan
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
