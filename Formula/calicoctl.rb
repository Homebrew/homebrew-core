class Calicoctl < Formula
  desc "Calico CLI tool"
  homepage "https://www.projectcalico.org"
  url "https://github.com/projectcalico/calicoctl.git",
      :tag      => "v3.9.0",
      :revision => "ab93db3bc81fe069e3a6cce521f1956870adfb88"

  bottle do
    cellar :any_skip_relocation
    sha256 "a2cf6617577b2c3edb96609ba9617a45057401dc237f84993b5eb90044f3c82f" => :mojave
    sha256 "36cf2ab2a8cafb82ef162b6c8ef2f83c9618cd4e502db48d0dd9f02d8f5460e9" => :high_sierra
    sha256 "3fd44a7fdf7f54cf8bcc711254c698762643f13fd79c79becc5eae326830467d" => :sierra
  end

  depends_on "go" => :build

  def install
    ENV["GO111MODULE"] = "on"
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
