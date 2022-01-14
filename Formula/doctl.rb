class Doctl < Formula
  desc "Command-line tool for DigitalOcean"
  homepage "https://github.com/digitalocean/doctl"
  url "https://github.com/digitalocean/doctl/archive/v1.69.0.tar.gz"
  sha256 "4ffbfe07ba2ea7d830855eb302f605c006bc5721c8c3288ed9b974d8c44e4fc6"
  license "Apache-2.0"
  head "https://github.com/digitalocean/doctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a4030122905cd98a819e91e15996d0cc3077f655061c40bbe9b46ec809c2d836"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "486e01ea4f99c67149a1268f4f4c9d37150152ccd967ac7b6667d94fcd2da302"
    sha256 cellar: :any_skip_relocation, monterey:       "7f627d402d3f0d8790d43ed31b6fcba7831c4537895432c7d7d0d04a01cda87c"
    sha256 cellar: :any_skip_relocation, big_sur:        "5708fee1340122a6489efc688d94628146ffc16c504c471202f795ac661e05e5"
    sha256 cellar: :any_skip_relocation, catalina:       "bff41e64b2e8640720e142e6285c8e2b488c676968c90e4d21b8bfa963059e91"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bd91fcdc19af6ec4111f6c6e1c53dfb5b362f1cbf47839a41173e5eb92626858"
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
