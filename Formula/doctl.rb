class Doctl < Formula
  desc "Command-line tool for DigitalOcean"
  homepage "https://github.com/digitalocean/doctl"
  url "https://github.com/digitalocean/doctl/archive/v1.43.0.tar.gz"
  sha256 "a55cc30b7e2ab37604eead742da6966c2c6715734a229263c6acae2092a932a0"
  head "https://github.com/digitalocean/doctl.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "a16f3b4e94f2956c0e5667cdf4e1759fe59bb9115f5cc27dc86df5dc70c04ddc" => :catalina
    sha256 "79da36955f6b18c9c4df53817e521001db3ea6c97f4b2031f05381f2341e72d0" => :mojave
    sha256 "0664c0c7a07190a003c252794619dec99c261832059af4d0066ad72c1bf7b87d" => :high_sierra
  end

  depends_on "go" => :build

  def install
    doctl_version = version.to_s.split(/\./)
    base_flag = "-X github.com/digitalocean/doctl"
    ldflags = %W[
      #{base_flag}.Major=#{doctl_version[0]}
      #{base_flag}.Minor=#{doctl_version[1]}
      #{base_flag}.Patch=#{doctl_version[2]}
      #{base_flag}.Label=release
    ].join(" ")

    system "go", "build", "-ldflags", ldflags, *std_go_args, "github.com/digitalocean/doctl/cmd/doctl"

    (bash_completion/"doctl").write `#{bin}/doctl completion bash`
    (zsh_completion/"_doctl").write `#{bin}/doctl completion zsh`
    (fish_completion/"doctl.fish").write `#{bin}/doctl completion fish`
  end

  test do
    assert_match "doctl version #{version}-release", shell_output("#{bin}/doctl version")
  end
end
