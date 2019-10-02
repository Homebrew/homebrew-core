class Doctl < Formula
  desc "Command-line tool for DigitalOcean"
  homepage "https://github.com/digitalocean/doctl"
  url "https://github.com/digitalocean/doctl/archive/v1.32.3.tar.gz"
  sha256 "e6e60c3bd6c3638a71e7be610c662344bca240194cc3de826e78a51739ca546d"
  head "https://github.com/digitalocean/doctl.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "5466cd64e1e8927630df08c55385f227b823c7633e6b95ac140e746f4ada0552" => :catalina
    sha256 "81d5c7d6d1b7adf883f3e027116320a09066419a0ff768c91c68c0ee8909c314" => :mojave
    sha256 "aaf6b30417bc1a6c2351d26ab8ff603c780bfd846f648d6ac2963ef154dda3df" => :high_sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath

    doctl_version = version.to_s.split(/\./)

    src = buildpath/"src/github.com/digitalocean/doctl"
    src.install buildpath.children
    src.cd do
      base_flag = "-X github.com/digitalocean/doctl"
      ldflags = %W[
        #{base_flag}.Major=#{doctl_version[0]}
        #{base_flag}.Minor=#{doctl_version[1]}
        #{base_flag}.Patch=#{doctl_version[2]}
        #{base_flag}.Label=release
      ].join(" ")
      system "go", "build", "-ldflags", ldflags, "-o", bin/"doctl", "github.com/digitalocean/doctl/cmd/doctl"
    end

    (bash_completion/"doctl").write `#{bin}/doctl completion bash`
    (zsh_completion/"doctl").write `#{bin}/doctl completion zsh`
  end

  test do
    assert_match "doctl version #{version}-release", shell_output("#{bin}/doctl version")
  end
end
