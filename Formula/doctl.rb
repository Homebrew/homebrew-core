class Doctl < Formula
  desc "Command-line tool for DigitalOcean"
  homepage "https://github.com/digitalocean/doctl"
  url "https://github.com/digitalocean/doctl/archive/v1.61.0.tar.gz"
  sha256 "5334fb1d2c169064d2a7584186bc4b3c48952e8af0a139447e890e204531356e"
  license "Apache-2.0"
  head "https://github.com/digitalocean/doctl.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "3505c0e0b2bf30ba272fdda55b89e8accd5b8ed6da42c63ad8bc87d7346f1c48"
    sha256 cellar: :any_skip_relocation, big_sur:       "139a9093e92bbf6329ba82c36ac5f868d533fc98ee83c26f3b58fdf37b7d13b9"
    sha256 cellar: :any_skip_relocation, catalina:      "da5ae950f0f38e15634d7560a2c6432755a3bba903fded26fa257cd94f09ccb0"
    sha256 cellar: :any_skip_relocation, mojave:        "625febd4d598f78760b3f11b6c7f3f5985afeb80e166a70ba796166b1c928c49"
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
