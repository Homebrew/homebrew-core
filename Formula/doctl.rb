require "language/go"

class Doctl < Formula
  desc "Command-line tool for DigitalOcean"
  homepage "https://github.com/digitalocean/doctl"
  url "https://github.com/digitalocean/doctl/archive/v1.2.0.tar.gz"
  sha256 "2c39570b8f5f69283ac2889b6de532680f7164ad326cd028410a8152b75b3389"
  head "https://github.com/digitalocean/doctl.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "48af20a20161133a88f7395a270c3d1dc6bb04bcf3c48a579b4cd3eef84a07b9" => :el_capitan
    sha256 "8996a0b8de97a39d01859e8e29a5c3947fad807353f08cd511177ebf570740eb" => :yosemite
    sha256 "285792f7a442ffd636a478d8d916db37d4f7b77d18d0fe908afa9e8d2ad3886c" => :mavericks
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
