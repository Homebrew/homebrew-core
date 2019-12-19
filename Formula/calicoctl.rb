class Calicoctl < Formula
  desc "Calico CLI tool"
  homepage "https://www.projectcalico.org"
  url "https://github.com/projectcalico/calicoctl.git",
      :tag      => "v3.11.0",
      :revision => "6c04a83961025c39f50fb7c22d8d6d100c425514"

  bottle do
    cellar :any_skip_relocation
    sha256 "3645ba0734b31b89ea89cf924cb48879474f428e95911bf15c6dec725711a040" => :catalina
    sha256 "caccf0194603c0701e1c0841cddf885941f4b7d9874e3105701a8c1d004645dd" => :mojave
    sha256 "9321e0bb74f2afbab55b0bd95c1f440f774434336ad005b5efa196bcd2afd71b" => :high_sierra
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
