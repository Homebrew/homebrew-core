class Calicoctl < Formula
  desc "Calico CLI tool"
  homepage "https://www.projectcalico.org"
  url "https://github.com/projectcalico/calicoctl.git",
      :tag      => "v3.13.0",
      :revision => "eb796e31bcbfb42af3c2470bd23826f630d03ab5"

  bottle do
    cellar :any_skip_relocation
    sha256 "2e71ef1f8f4493639731754a95969b8d597e026448ff6c5a95d1bf81ca3a80c1" => :catalina
    sha256 "7e55a0bc0b0ea5a7655ea5b49b51d1f01ecbdea628c3d810ca4454a4facb793f" => :mojave
    sha256 "2c65c176c307f70698dc4fd157e7eb016df7beeee94602215e1da6924dd72fe0" => :high_sierra
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
