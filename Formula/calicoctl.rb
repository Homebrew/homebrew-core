class Calicoctl < Formula
  desc "Calico CLI tool"
  homepage "https://www.projectcalico.org"
  url "https://github.com/projectcalico/calicoctl.git",
      :tag      => "v3.13.0",
      :revision => "eb796e31bcbfb42af3c2470bd23826f630d03ab5"

  bottle do
    cellar :any_skip_relocation
    sha256 "62fa23b4871b8a7bd2fc26b92d95e03708302b02e9ffc4e9666d80aa0fcbf0b7" => :catalina
    sha256 "e533bcee57b4cca345abd618393212210fa541f2a89ff2e850da6187d8f62daf" => :mojave
    sha256 "3e8fcb2eaa4c4a499cc959c49b953d56a4f853e4ec2773b5d4a533b7452eb050" => :high_sierra
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
