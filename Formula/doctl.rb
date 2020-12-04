class Doctl < Formula
  desc "Command-line tool for DigitalOcean"
  homepage "https://github.com/digitalocean/doctl"
  url "https://github.com/digitalocean/doctl/archive/v1.54.0.tar.gz"
  sha256 "bdb2dfb18ac0047c55343a74aa872cd5251881657d88ceb432af894042767d09"
  license "Apache-2.0"
  head "https://github.com/digitalocean/doctl.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "5cc52d0f474051b58b3d8f387948a03e1c824608356fc997bd6c31d1f046735a" => :big_sur
    sha256 "75296dacff776da4a7174ab1d97eb6a2dc4721fce76ee42b7490e78639e365d9" => :catalina
    sha256 "fd8b32694fc91a7e32c1d0f6e4edeea55a438af13d9b643488c06ff903076581" => :mojave
  end

  depends_on "go" => :build

  def install
    base_flag = "-X github.com/digitalocean/doctl"
    ldflags = %W[
      #{base_flag}.Major=#{version.major}
      #{base_flag}.Minor=#{version.minor}
      #{base_flag}.Patch=#{version.patch}
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
