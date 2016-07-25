class Doctl < Formula
  desc "Command-line tool for DigitalOcean"
  homepage "https://github.com/digitalocean/doctl"
  url "https://github.com/digitalocean/doctl/archive/v1.3.1.tar.gz"
  sha256 "3b83173a00a6f0e94e250cf5e77845d70cacd02529b7791076a5c7e24320c394"
  head "https://github.com/digitalocean/doctl.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "fb29532f21112b271eb1a841a63ec7ce6064b5c23dddb18a717fd22bd03bda43" => :el_capitan
    sha256 "42ac1012d144a21848b19161fcf8a82ca5f01cc14995797b5bbe8be6bc3b4b6a" => :yosemite
    sha256 "e21355def87f4d43f05015fa674aaa616ec296baffaad1778d8872b0ab8cee54" => :mavericks
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
