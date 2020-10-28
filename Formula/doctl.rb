class Doctl < Formula
  desc "Command-line tool for DigitalOcean"
  homepage "https://github.com/digitalocean/doctl"
  url "https://github.com/digitalocean/doctl/archive/v1.49.0.tar.gz"
  sha256 "5b62b595c9503b94a3492cf7f71090d964243b9d901925978cb20f7215208d3a"
  license "Apache-2.0"
  head "https://github.com/digitalocean/doctl.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "309dbdd78bc2346137a54bcab31d1c207ef2fda899f10d226a61af7bedd8d9a7" => :catalina
    sha256 "50f85bb14446422834cf11a9cb156355c71be7345233c1297009e5bbe2aadbc3" => :mojave
    sha256 "a7826a5f340e4f81fe7e41b8f09d7c015dbdc2da60432e656d1a7fbc788c0f9a" => :high_sierra
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
