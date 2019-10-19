class Calicoctl < Formula
  desc "Calico CLI tool"
  homepage "https://www.projectcalico.org"
  url "https://github.com/projectcalico/calicoctl.git",
      :tag      => "v3.10.0",
      :revision => "7968b525711f3f4059f837bfca8328d1d12c5cef"

  bottle do
    cellar :any_skip_relocation
    sha256 "2078b19df33eedc4e5d0d480ece18e057bfcc1f229cb280e59893b679badf1d6" => :catalina
    sha256 "bdad39e6df742a686e51d449166cd6e7907c42a99ba3df6dc8261754d3d45723" => :mojave
    sha256 "546593c454fe0f7be24b4b32bf25deb3c45082aee6c2377b1d685261df633232" => :high_sierra
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
