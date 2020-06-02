class Doctl < Formula
  desc "Command-line tool for DigitalOcean"
  homepage "https://github.com/digitalocean/doctl"
  url "https://github.com/digitalocean/doctl/archive/v1.44.0.tar.gz"
  sha256 "5e4315446918cc2aa97dc8a87cbfea893b2e826741417dec7e5519483518c5af"
  head "https://github.com/digitalocean/doctl.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "f84719eaac6d49ffebf3f0141a0914737c7038ea87cc3000627744e000524729" => :catalina
    sha256 "07044fcbf791eff9183632afa4b513d9fd95ffa6e067761436bf17e18a525936" => :mojave
    sha256 "cd77b636e4c9921cc6f262f3c4d586f80e3138a10995097776ef596430710522" => :high_sierra
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
