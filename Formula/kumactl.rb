class Kumactl < Formula
  desc "Kuma control plane command-line utility"
  homepage "https://kuma.io/"
  url "https://github.com/kumahq/kuma/archive/1.1.0.tar.gz"
  sha256 "d6f3d6f31b04d6458f0ae1cff98fe5c7a5d09dd158e46cd7c2af66cb483d8c64"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "7b415c7973e2b16bd277ea25e44f481de132feea56192bdfcd1578328f2d37a0"
    sha256 cellar: :any_skip_relocation, big_sur:       "08c10bd45d048ae1ddbad58be8e9e23c374b75ba39a249535228db43c54a3bf4"
    sha256 cellar: :any_skip_relocation, catalina:      "641715bccc91605062973f89dbc4994a0f0b153e4f1174fa4e75f7777dbd4e0d"
    sha256 cellar: :any_skip_relocation, mojave:        "9fb27b4354c5cb92423db822f50ef77283fe939b8330c81c70ac4a7cf18bdc21"
  end

  depends_on "go" => :build

  def install
    srcpath = buildpath/"src/kuma.io/kuma"
    srcpath.install buildpath.children

    cd srcpath do
      system "make", "build/kumactl", "BUILD_INFO_VERSION=#{version}"
      bin.install Dir["build/artifacts-*/kumactl/kumactl"].first
    end

    output = Utils.safe_popen_read("#{bin}/kumactl", "completion", "bash")
    (bash_completion/"kumactl").write output

    output = Utils.safe_popen_read("#{bin}/kumactl", "completion", "zsh")
    (zsh_completion/"_kumactl").write output

    output = Utils.safe_popen_read("#{bin}/kumactl", "completion", "fish")
    (fish_completion/"kumactl.fish").write output
  end

  test do
    assert_match "Management tool for Kuma.", shell_output("#{bin}/kumactl")
    assert_match version.to_s, shell_output("#{bin}/kumactl version 2>&1")

    touch testpath/"config.yml"
    assert_match "Error: no resource(s) passed to apply",
    shell_output("#{bin}/kumactl apply -f config.yml 2>&1", 1)
  end
end
