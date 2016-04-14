require "language/go"

class Doctl < Formula
  desc "Command-line tool for DigitalOcean"
  homepage "https://github.com/digitalocean/doctl"
  url "https://github.com/digitalocean/doctl/archive/v1.0.2.tar.gz"
  sha256 "7a28bd0f9e68eee41761e32267a0d63329c6f0e16e0d8b5afb4a8286b914e98a"
  head "https://github.com/digitalocean/doctl.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "e5ed7db05132da3826632d4f4505f11352e3135e8f023a732aea888cb145bd56" => :el_capitan
    sha256 "4bfd2fbdcb0a8bfaf6613eefecd6736b8875ea152d0b1743af27c604b63c4b1e" => :yosemite
    sha256 "527289674fd9bbd887b43ed65a58e8089e40390d65a139a2c06f1909b342cda4" => :mavericks
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath

    mkdir_p buildpath/"src/github.com/digitalocean/"
    ln_sf buildpath, buildpath/"src/github.com/digitalocean/doctl"
    Language::Go.stage_deps resources, buildpath/"src"

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
    assert_match "doctl version #{version.to_s}-release", shell_output("#{bin}/doctl version")
  end
end
