class Kumactl < Formula
  desc "Kuma control plane command-line utility"
  homepage "https://kuma.io/"
  url "https://github.com/kumahq/kuma/archive/1.1.0.tar.gz"
  sha256 "d6f3d6f31b04d6458f0ae1cff98fe5c7a5d09dd158e46cd7c2af66cb483d8c64"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "2c85b47915f9250a3f8f125b0fde706cdafe27f3f98ef18983279507367cb358"
    sha256 cellar: :any_skip_relocation, big_sur:       "3398a94e4293f949de0c472af2655754ba72c5fdd33b617f96684df5806b2f58"
    sha256 cellar: :any_skip_relocation, catalina:      "9655ebea7590c26e340a7516f000b347bf93cc0c83cc5c4db3e46c9e2a6118b1"
    sha256 cellar: :any_skip_relocation, mojave:        "a909c6e55e37ec96d522a3b389b1ad17bda4208be4d2b7d72b4cf2cde3f68ff4"
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
