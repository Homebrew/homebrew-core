class Doctl < Formula
  desc "Command-line tool for DigitalOcean"
  homepage "https://github.com/digitalocean/doctl"
  url "https://github.com/digitalocean/doctl/archive/v1.76.0.tar.gz"
  sha256 "b30704990c17e8a4f55b65814c8fb87ad3375b95123cbfdfc997b6a2012c98ac"
  license "Apache-2.0"
  head "https://github.com/digitalocean/doctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1218bdb90b33bed7cb2f40d0cf7709ff3049569e0e77dd9df80878d7d471dd50"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "124199a21e86cc893fdb5403deb05482fda21178466a71d5b47b164c83432ea8"
    sha256 cellar: :any_skip_relocation, monterey:       "d71c486461ce7c6fe32e747c60e5327864ed723be54522fa3cfd2d2bd28812bf"
    sha256 cellar: :any_skip_relocation, big_sur:        "a76554568021144425933366cd90935e84f4d01cde05f22799db3f09972ec1ce"
    sha256 cellar: :any_skip_relocation, catalina:       "c356217ebdaf9447917fe7ac457a29906c24e904b1f767c53d5a358aa4d38cc2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b108dcfaf884afd3328b237ee5b809fd4f2e0b4ca80ce80f2790bc131b88fc70"
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
