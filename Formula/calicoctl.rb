class Calicoctl < Formula
  desc "Calico CLI tool"
  homepage "https://www.projectcalico.org"
  url "https://github.com/projectcalico/calicoctl.git",
      :tag      => "v3.10.0",
      :revision => "7968b525711f3f4059f837bfca8328d1d12c5cef"

  bottle do
    cellar :any_skip_relocation
    sha256 "7452d9dd0e1bd83d7f7b34ef9bfca8acd27c33fce2f554997be726d471300182" => :catalina
    sha256 "96562890107ff4bf141818f6772a3f61b46e8f71b2262f1fc5d96b10896e19e9" => :mojave
    sha256 "01ee330f4b9f9c3ddbcfd0d6fea283aac23be657c4a6adc9657d0e7a2e6fef1b" => :high_sierra
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
