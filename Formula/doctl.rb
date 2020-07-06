class Doctl < Formula
  desc "Command-line tool for DigitalOcean"
  homepage "https://github.com/digitalocean/doctl"
  url "https://github.com/digitalocean/doctl/archive/v1.45.1.tar.gz"
  sha256 "c6f3311fc8279e94bf3294d95a93d09deb96a6f2a24efe0a3e8fef33c848e7ce"
  license "Apache-2.0"
  head "https://github.com/digitalocean/doctl.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "e6e9288be9f8a0b1481dfa693a8a17d3ccb4712f6c5f5c01ca0ef90924e685f3" => :catalina
    sha256 "eade457a9301889f62515066726d7e762675b40aa6bc5a67748e148021561fa7" => :mojave
    sha256 "44255495677369f45527289fdde2588bd5893721d8362ab55e32a40c6cb60590" => :high_sierra
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
