class Doctl < Formula
  desc "Command-line tool for DigitalOcean"
  homepage "https://github.com/digitalocean/doctl"
  url "https://github.com/digitalocean/doctl/archive/v1.57.0.tar.gz"
  sha256 "a5a3eda3075f141f419d7bf1bd4e8e0decf729b5a7ff82b5b01a6331c4f2afa9"
  license "Apache-2.0"
  head "https://github.com/digitalocean/doctl.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "e8c7495db634640207c0543adb3ac94cbe8e5935a4ac6996331318199e9b855d"
    sha256 cellar: :any_skip_relocation, big_sur:       "80c8a21913acd9afab0147fb4d0f8f031e5d3bd375e6bac1a8c935a8ed89b879"
    sha256 cellar: :any_skip_relocation, catalina:      "58299dc4927e418e6bd5094612647ac3f3ccff384325b38db686c0bf8a02a4ad"
    sha256 cellar: :any_skip_relocation, mojave:        "394ac21e6c0a64fbae65ffa2c2be5e0d167976446f69881a0a29a1c427162ae9"
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
