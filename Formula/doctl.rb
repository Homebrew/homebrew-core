class Doctl < Formula
  desc "Command-line tool for DigitalOcean"
  homepage "https://github.com/digitalocean/doctl"
  url "https://github.com/digitalocean/doctl/archive/v1.63.1.tar.gz"
  sha256 "292a023cc9525ff131612cf26412a1507c1f4daecbeefe4f931157f58b891fa0"
  license "Apache-2.0"
  head "https://github.com/digitalocean/doctl.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "544837c0d731222fa941b1ba3dd57112e140e31fb84bcff85ada7f80c49cc141"
    sha256 cellar: :any_skip_relocation, big_sur:       "578327701392527df4c00f5b402595b23a5be15a201e45dd82215cca6d6adb6f"
    sha256 cellar: :any_skip_relocation, catalina:      "90045e0b9e0598286c067c48dcfbab6be840e315e6e32700f7865d89bdd71714"
    sha256 cellar: :any_skip_relocation, mojave:        "b364315e9bbf3e3b75e7ef6573c703f339c71456dfceb39196048169b6f9ba2c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "44d1c6d8a19cc8f4c0ae0a44d5a5cfc4288c94b614e742fb54c55828ef74932b"
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
