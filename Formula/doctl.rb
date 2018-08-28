class Doctl < Formula
  desc "Command-line tool for DigitalOcean"
  homepage "https://github.com/digitalocean/doctl"
  url "https://github.com/digitalocean/doctl/archive/v1.9.0.tar.gz"
  sha256 "3187f8b989d3e284c90ec1ef5252e8949319835b0e62cafe7b8df41c5ca8f422"
  head "https://github.com/digitalocean/doctl.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "e509282cb8475ef241aaafc0f506569a5874917d713efb10f75bc3e8cb70c2dd" => :mojave
    sha256 "bf09e10dade281805f42277197a1e0a383a0df97ac99df800cf80bf1fbdf0ca1" => :high_sierra
    sha256 "f70e66f7e60c2fb3a301b056c96b8fbbbb77dcd8ca7cf4380960ec8eec9e66b2" => :sierra
    sha256 "9f20dc45ca2bdc7349560e2a0980862e6ff1378497909212a2a698760e12050b" => :el_capitan
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath

    mkdir_p buildpath/"src/github.com/digitalocean/"
    ln_sf buildpath, buildpath/"src/github.com/digitalocean/doctl"

    doctl_version = version.to_s.split(/\./)
    base_flag = "-X github.com/digitalocean/doctl"
    ldflags = %W[
      #{base_flag}.Major=#{doctl_version[0]}
      #{base_flag}.Minor=#{doctl_version[1]}
      #{base_flag}.Patch=#{doctl_version[2]}
      #{base_flag}.Label=release
    ].join(" ")
    system "go", "build", "-ldflags", ldflags, "github.com/digitalocean/doctl/cmd/doctl"
    bin.install "doctl"

    (bash_completion/"doctl").write `#{bin}/doctl completion bash`
    (zsh_completion/"doctl").write `#{bin}/doctl completion zsh`
  end

  test do
    assert_match "doctl version #{version}-release", shell_output("#{bin}/doctl version")
  end
end
