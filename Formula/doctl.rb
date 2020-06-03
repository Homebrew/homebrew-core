class Doctl < Formula
  desc "Command-line tool for DigitalOcean"
  homepage "https://github.com/digitalocean/doctl"
  url "https://github.com/digitalocean/doctl/archive/v1.45.0.tar.gz"
  sha256 "eaafdec52ad3de0f3f4b923a91cc944e87c3442c869bce673b5b4ef33047d4af"
  head "https://github.com/digitalocean/doctl.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "4c2b715030e9a18fb7dbc474ba596d701746b61d011efd535b12a626cc6abab6" => :catalina
    sha256 "ad2fa8106866560f13dde179347107d2928b69b3808e6d4d0475239c25514139" => :mojave
    sha256 "bf85715bbfd2ee66ed53575374de287492853ddd12a872cf7bfd1d6cf803dfcb" => :high_sierra
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
