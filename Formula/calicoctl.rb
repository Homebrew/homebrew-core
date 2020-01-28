class Calicoctl < Formula
  desc "Calico CLI tool"
  homepage "https://www.projectcalico.org"
  url "https://github.com/projectcalico/calicoctl.git",
      :tag      => "v3.12.0",
      :revision => "84a21b3b5152a32ca4df787678e43a8b32598f3d"

  bottle do
    cellar :any_skip_relocation
    sha256 "3918f46d2ce63e01bb65fceb117e9a8e5355d26ccb32615b2541369180c3ea1d" => :catalina
    sha256 "e3360b62ab670e18cfc33fa10aa1f0db0055bd557577be89f688a547466da483" => :mojave
    sha256 "e28659a026a14ab0d31f0a3ea9a28f58b0cb574f798b7f363b752b7475973573" => :high_sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath

    dir = buildpath/"src/github.com/projectcalico/calicoctl"
    dir.install buildpath.children

    cd dir do
      commands = "github.com/projectcalico/calicoctl/calicoctl/commands"
      ldflags = "-X #{commands}.VERSION=#{stable.specs[:tag]} -X #{commands}.GIT_REVISION=#{stable.specs[:revision][0, 8]} -s -w"
      system "go", "build", "-v", "-o", "dist/calicoctl-darwin-amd64", "-ldflags", ldflags, "calicoctl/calicoctl.go"
      bin.install "dist/calicoctl-darwin-amd64" => "calicoctl"
      prefix.install_metafiles
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/calicoctl version", 1)
  end
end
