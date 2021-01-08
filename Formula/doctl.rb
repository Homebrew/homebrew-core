class Doctl < Formula
  desc "Command-line tool for DigitalOcean"
  homepage "https://github.com/digitalocean/doctl"
  url "https://github.com/digitalocean/doctl/archive/v1.54.1.tar.gz"
  sha256 "f61746217994a7270ac32d9707a7c2906e94821238bdb938b0e3be70f2f2dcb5"
  license "Apache-2.0"
  head "https://github.com/digitalocean/doctl.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "b5eee0059ab2a42a8d43269c2dc33820097ec548dfbc229003e3176b59b472cb" => :big_sur
    sha256 "4c2d81637cdce18cbdf794a0db6b88cb9c7446577b81ce732e7af7f3dcb3f63e" => :arm64_big_sur
    sha256 "6cce0b7933da1243b5e2d2bff4a80a1161e7a000f08da3da47b285835123accb" => :catalina
    sha256 "10986533df780bc80438b6457193ee948692f2793c4e31468cb44768ac07f71a" => :mojave
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
