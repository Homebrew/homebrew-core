class Doctl < Formula
  desc "Command-line tool for DigitalOcean"
  homepage "https://github.com/digitalocean/doctl"
  url "https://github.com/digitalocean/doctl/archive/v1.75.0.tar.gz"
  sha256 "3fe102d60f57ee8f9bd4a8f5094fd3ddfdf7af1bbaf35c7b8286a9ae3c8a8f3e"
  license "Apache-2.0"
  head "https://github.com/digitalocean/doctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dda0c5fd894d39f6766107391e2c7373aae26b8b55bc03a0a6089226d9cd9ca4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "20a57316c0731beec19e3c0f3c69bbff95c7c71a3b2baa0ec000186fca7db21d"
    sha256 cellar: :any_skip_relocation, monterey:       "10df1f44121351ea7571c9b84b373ea6959900263d9e32c95818f44c9be66b96"
    sha256 cellar: :any_skip_relocation, big_sur:        "8f5071172e82754f753db9ea94c9e07777b03e78a795e6d02f3105a77c243e26"
    sha256 cellar: :any_skip_relocation, catalina:       "8ef3d7596ff713b268024fb5e5f72ac8fcbdac9018697c49be0f53c0dc8e06d5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "31266cc3be8fca18776884e8f7a620947843de671efedc8f39a99c2e45c20026"
  end

  depends_on "go" => :build

  def install
    base_flag = "-X github.com/digitalocean/doctl"
    ldflags = %W[
      #{base_flag}.Major=#{version.major}
      #{base_flag}.Minor=#{version.minor}
      #{base_flag}.Patch=#{version.patch}
      #{base_flag}.Label=release
    ]

    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/doctl"

    (bash_completion/"doctl").write `#{bin}/doctl completion bash`
    (zsh_completion/"_doctl").write `#{bin}/doctl completion zsh`
    (fish_completion/"doctl.fish").write `#{bin}/doctl completion fish`
  end

  test do
    assert_match "doctl version #{version}-release", shell_output("#{bin}/doctl version")
  end
end
