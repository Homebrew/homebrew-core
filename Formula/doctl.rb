class Doctl < Formula
  desc "Command-line tool for DigitalOcean"
  homepage "https://github.com/digitalocean/doctl"
  url "https://github.com/digitalocean/doctl/archive/v1.5.0.tar.gz"
  sha256 "66110a1377e0ca2fcb17bc2ac04e00aa2da5e961906419135772e3157c70f7f4"
  head "https://github.com/digitalocean/doctl.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "db724a87e33308a398042d7d1f753b8fdab9486cd8423e7a2a59965ac666864d" => :sierra
    sha256 "ead0fb58a77d7e319b3014e4a4d31fe569bdbd016ca6f93da0d1713b479e9c80" => :el_capitan
    sha256 "85f6e5c43246cf287b7a5359d99f85b7e21338b87852cf01a8772bd51bb5b722" => :yosemite
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
  end

  test do
    assert_match "doctl version #{version}-release", shell_output("#{bin}/doctl version")
  end
end
