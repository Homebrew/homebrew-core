class Calicoctl < Formula
  desc "Calico CLI tool"
  homepage "https://www.projectcalico.org"
  url "https://github.com/projectcalico/calicoctl.git",
      :tag      => "v3.13.1",
      :revision => "eb796e31bcbfb42af3c2470bd23826f630d03ab5"

  bottle do
    cellar :any_skip_relocation
    sha256 "7eeb59be398ce41cbb93e460d68d45dc314594a98c468832e632d88e75871642" => :catalina
    sha256 "68e2370ecdbf3104af9ff7c1e31db62e9b07f3f2eda1f10b3e3320b55a6ee725" => :mojave
    sha256 "57f49e06edbada436103f164add3adc11b04486d9dbcc45c9a4faab11b375a4b" => :high_sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath

    dir = buildpath/"src/github.com/projectcalico/calicoctl"
    dir.install buildpath.children

    cd dir do
      commands = "github.com/projectcalico/calicoctl/calicoctl/commands"
      system "go", "build", "-v", "-o", "dist/calicoctl-darwin-amd64",
                            "-ldflags", "-X #{commands}.VERSION=#{stable.specs[:tag]} " \
                                        "-X #{commands}.GIT_REVISION=#{stable.specs[:revision][0, 8]} " \
                                        "-s -w",
                            "calicoctl/calicoctl.go"
      bin.install "dist/calicoctl-darwin-amd64" => "calicoctl"
      prefix.install_metafiles
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/calicoctl version", 1)
  end
end
