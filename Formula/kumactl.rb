class Kumactl < Formula
  desc "Kuma control plane command-line utility"
  homepage "https://kuma.io/"
  url "https://github.com/kumahq/kuma/archive/1.1.4.tar.gz"
  sha256 "8eaf9a7cf632efef73c0101a2ce11acb29323bb10bde4876435d98ed8c9e67a8"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "bcdf662d4abc2927bd4e58a38e61509f07304e30f514fd249b0cf13d0d4ee2aa"
    sha256 cellar: :any_skip_relocation, big_sur:       "3ac16f985843955c4ab6258555a65fe1d6c952a236984e4257003daae43a6afc"
    sha256 cellar: :any_skip_relocation, catalina:      "b83ee105380e931f00a120cea36c3703fc05a70c5744fb0352d8f981b09bce60"
    sha256 cellar: :any_skip_relocation, mojave:        "d4dda98e648a396daf88ae9c99c7aeddeb6717f9e27221ab22262c5b499d17ff"
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
