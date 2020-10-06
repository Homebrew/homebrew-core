class Doctl < Formula
  desc "Command-line tool for DigitalOcean"
  homepage "https://github.com/digitalocean/doctl"
  url "https://github.com/digitalocean/doctl/archive/v1.48.0.tar.gz"
  sha256 "43f4be1a5316688579c3df1846dc7088478dc5ddc3e4fa1176a953609123f046"
  license "Apache-2.0"
  head "https://github.com/digitalocean/doctl.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "b3e9448de8b9c0c7d16b939c9625b6b0036909d4779c0c1e5bdc16d3579c233a" => :catalina
    sha256 "a0e99fb5737f1b2418b97799391b4741218d39cc0da5faf19bebf65b51d1f03f" => :mojave
    sha256 "c79a0cdf6687b25936c94ab0287257392c404b3f68a9f8b7eeb770149cc71a37" => :high_sierra
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
