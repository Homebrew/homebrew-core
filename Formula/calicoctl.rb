class Calicoctl < Formula
  desc "Calico CLI tool"
  homepage "https://www.projectcalico.org"
  url "https://github.com/projectcalico/calicoctl.git",
      :tag      => "v3.9.1",
      :revision => "ab93db3bc81fe069e3a6cce521f1956870adfb88"

  bottle do
    cellar :any_skip_relocation
    sha256 "4516287eafcb97b6d039c31ea45ef4cbabf7325d9c342a9a88d04ac5ea8199fc" => :catalina
    sha256 "8941d3769e4ec26e754a801b1a52194e0cdc285fda59e682c2fee245db4acfb3" => :mojave
    sha256 "24210905f607a5960e9ca6112025446a6ef6867bc100013bdc3dc42f4ecee877" => :high_sierra
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
