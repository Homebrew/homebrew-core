class Doctl < Formula
  desc "Command-line tool for DigitalOcean"
  homepage "https://github.com/digitalocean/doctl"
  url "https://github.com/digitalocean/doctl/archive/v1.5.0.tar.gz"
  sha256 "66110a1377e0ca2fcb17bc2ac04e00aa2da5e961906419135772e3157c70f7f4"
  head "https://github.com/digitalocean/doctl.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "145dd12baa5b95270997b8c2c148cd50e229e35155bccb1cab41fa11048b4d5f" => :sierra
    sha256 "d49767c9c7c1ada9f1e5698905294b059181f4b2a8873a17efd37c39f2293a50" => :el_capitan
    sha256 "fb15026d64104ae934c2de11d259b03073645307de481321140fb6070a06f167" => :yosemite
    sha256 "5c1796da8e8efb8e6cb9a16d8ed2ad8bab3b34a20b27d096f544f9e70c1adcfb" => :mavericks
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
