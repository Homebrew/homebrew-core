require "language/go"

class Doctl < Formula
  desc "Command-line tool for DigitalOcean"
  homepage "https://github.com/digitalocean/doctl"
  url "https://github.com/digitalocean/doctl/archive/v1.2.0.tar.gz"
  sha256 "2c39570b8f5f69283ac2889b6de532680f7164ad326cd028410a8152b75b3389"
  head "https://github.com/digitalocean/doctl.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "d488bd227e29d9483c8cffa1181233fa3d66c7e065fa5cd66abc6e2eebfd3f08" => :el_capitan
    sha256 "d5917a2962f24087c0a106ee8896e8691bf5e7410ef30ecc071259f2f077455a" => :yosemite
    sha256 "c198bf12a5b7adad667a9e05cc165fa20091d0a7bfb62eb46d57b8e3c6c110fd" => :mavericks
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
