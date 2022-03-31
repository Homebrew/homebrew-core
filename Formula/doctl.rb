class Doctl < Formula
  desc "Command-line tool for DigitalOcean"
  homepage "https://github.com/digitalocean/doctl"
  url "https://github.com/digitalocean/doctl/archive/v1.73.0.tar.gz"
  sha256 "cc7a6f91febf4d40f8afca0fe4ddfa7aa9be3572e3a0124fca2865e35b52ef00"
  license "Apache-2.0"
  head "https://github.com/digitalocean/doctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b1093b5dfb22aaa18e1889439b6ec59b5cb765a3de92a50719a33110425edbe5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4f0d16718813078e9a84e6f245d62d3e9f76c399a24f60eb073b3c0ce5ef5a55"
    sha256 cellar: :any_skip_relocation, monterey:       "b1d5ee353d78a7d06c67dedc6317daff179934b01663105394ca425fc5935826"
    sha256 cellar: :any_skip_relocation, big_sur:        "2c2ad95d7117d493177400b257aa638e99de3063f66b103e57729358bdf4fb7d"
    sha256 cellar: :any_skip_relocation, catalina:       "2fd44c5e121824bd8325fa0af5a6e877cef2358c8dd0e59b7f72c98a2a4d5f3d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "96c321c935c6f550150ddfa2689db4be686d04a1dacb22196433fafb94922412"
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
