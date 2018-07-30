class GoJira < Formula
  desc "Simple jira command-line client in Go"
  homepage "https://github.com/Netflix-Skunkworks/go-jira"
  url "https://github.com/Netflix-Skunkworks/go-jira/archive/v1.0.18.tar.gz"
  sha256 "636a5c0a64441075b7cf5c8c452f5bd2c3788e9ed3201eb8de416f4b627b7f8d"

  bottle do
    cellar :any_skip_relocation
    sha256 "998f112c60677a6148d494a228cb0c7ce52b1305ca592f390303aa4bbeafa1c3" => :high_sierra
    sha256 "f69c2762ed8579b1e90039f87a4729e08713c44b3769a10a4d05ea39534532d6" => :sierra
    sha256 "feac86e0055b80f2553211f21db03a8e56eb6e1f7e229afff6aa395c576a3aff" => :el_capitan
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
