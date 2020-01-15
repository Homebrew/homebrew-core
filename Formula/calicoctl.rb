class Calicoctl < Formula
  desc "Calico CLI tool"
  homepage "https://www.projectcalico.org"
  url "https://github.com/projectcalico/calicoctl.git",
      :tag      => "v3.11.1",
      :revision => "6c04a83961025c39f50fb7c22d8d6d100c425514"

  bottle do
    cellar :any_skip_relocation
    sha256 "a71b6903e8f3e335dee4d8d213cbe581944fe11a5c1b579c694654ae76ba2c77" => :catalina
    sha256 "eaa4ff648279776c26f7a8b85f80075a77db8c145bd288a2a834bfc593163502" => :mojave
    sha256 "21ba7e939dc75d10260c72ccbbe23bb00dfe979007dcafe04200e4ea8b1048d4" => :high_sierra
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
