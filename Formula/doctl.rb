class Doctl < Formula
  desc "Command-line tool for DigitalOcean"
  homepage "https://github.com/digitalocean/doctl"
  url "https://github.com/digitalocean/doctl/archive/v1.65.0.tar.gz"
  sha256 "b2ab4f123813ee3fdcc750b7c8f7bd9764dfa1647c54514413940449ef78cab5"
  license "Apache-2.0"
  head "https://github.com/digitalocean/doctl.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "c442259ca09852b1c19fd6217c4c7f2f6128d225d004e6d2ab496c0da2a7317c"
    sha256 cellar: :any_skip_relocation, big_sur:       "e86f423a95e66ac52f95260c6ee5f31de2d14407aa7228e60d673bef93ce64f9"
    sha256 cellar: :any_skip_relocation, catalina:      "367d604509d4821204ffc997a09f04a24bd646446d25486374cb156c41deabd1"
    sha256 cellar: :any_skip_relocation, mojave:        "7bdd20fb58a102d1035ea5ccff9514b5f32e3281ac8ae76caf895b5ddd6e9a0d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f085be99de8bb758f92368c5829e1c515e89e0186d0f55186fee4310f9409f53"
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
