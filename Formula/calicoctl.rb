class Calicoctl < Formula
  desc "Calico CLI tool"
  homepage "https://www.projectcalico.org"
  url "https://github.com/projectcalico/calicoctl.git",
      :tag      => "v3.11.0",
      :revision => "6c04a83961025c39f50fb7c22d8d6d100c425514"

  bottle do
    cellar :any_skip_relocation
    sha256 "d14aaba54109565dad4bc7e4f4e519e7768ee450c864484b08e40ef37d1716fb" => :catalina
    sha256 "48bfb950f9cf29c57d7718254c354de79b04fab045b76126b6b439ac5cfd8445" => :mojave
    sha256 "4ab136bfd9742073bf160df27220180e54e2fe5db5d5a0021bd84139c9aa708a" => :high_sierra
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
