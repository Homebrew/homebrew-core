class Doctl < Formula
  desc "Command-line tool for DigitalOcean"
  homepage "https://github.com/digitalocean/doctl"
  url "https://github.com/digitalocean/doctl/archive/v1.63.1.tar.gz"
  sha256 "292a023cc9525ff131612cf26412a1507c1f4daecbeefe4f931157f58b891fa0"
  license "Apache-2.0"
  head "https://github.com/digitalocean/doctl.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "892488e1ffc5d541dc5105bfdd5efa0c711d31619dfa8cea43fb2f5314bdfb33"
    sha256 cellar: :any_skip_relocation, big_sur:       "3a023b3ba8640775c10700393688e52c145b2fcca7952f2a8227b5f3e5b002b8"
    sha256 cellar: :any_skip_relocation, catalina:      "2779eb2c226bbe74ec24c2b7762b700cbdf75f5d533f4f0622361e2378109e90"
    sha256 cellar: :any_skip_relocation, mojave:        "d1b2fe09d6bc636bc146792a06e64f551bc468abc0bea35816c7caac16177d2b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aa59fd85b6c0f3291e92ee33d5a220d7eacacffb7b721b078ca4d91045146d18"
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
