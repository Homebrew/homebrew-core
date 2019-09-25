class Calicoctl < Formula
  desc "Calico CLI tool"
  homepage "https://www.projectcalico.org"
  url "https://github.com/projectcalico/calicoctl.git",
      :tag      => "v3.9.0",
      :revision => "ab93db3bc81fe069e3a6cce521f1956870adfb88"

  bottle do
    cellar :any_skip_relocation
    sha256 "e213ffd81015424344f24c60e3aff21699a8298bf377058c7863c6c8893c3022" => :mojave
    sha256 "1495e2130cb9f6a4f94b82fa21b70c5f1c888cc20bf322e1f9522597f1847b7e" => :high_sierra
    sha256 "c6707a53e90de2cf62b864c58336a38f901591c17bfe8acd62c71eb0f82f1130" => :sierra
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
