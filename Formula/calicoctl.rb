class Calicoctl < Formula
  desc "Calico CLI tool"
  homepage "https://www.projectcalico.org"
  url "https://github.com/projectcalico/calicoctl.git",
      :tag      => "v3.10.1",
      :revision => "4aaff8e910a6cf9f77e3e82f1ef68e91bd5a8e9a"

  bottle do
    cellar :any_skip_relocation
    sha256 "5ef71fb66898bba896d6af7e0337b0e8df424f5f1e3bb4fefd30c5b81a83afed" => :catalina
    sha256 "a4f07320159325cf33ddc2f817ec4aa8169c7a774b01c78141b81d4316be7a26" => :mojave
    sha256 "0dfcc0d09528ba30ed3b66c5c5a52c8f0b4a94d5c48c41e03344f3fe2ff1869c" => :high_sierra
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
