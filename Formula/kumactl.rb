class Kumactl < Formula
  desc "Kuma control plane command-line utility"
  homepage "https://kuma.io/"
  url "https://github.com/kumahq/kuma/archive/1.1.1.tar.gz"
  sha256 "7c8086807fcdfa33c95dc9fa4a4fbf8cbafd22b50d749d14d877a64299381914"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "9891ad7f0a45a1bc41de6833fe7b2912c5e70c602eecf78cc3c49908f6af2975"
    sha256 cellar: :any_skip_relocation, big_sur:       "20629acfd92489281588abffe2de1e5c1c4750914a4468efa9c9a45240b338bf"
    sha256 cellar: :any_skip_relocation, catalina:      "1cda3c8d8888ffc019a21cb1ff2dd8b87715e3448b362c3be02db5fca5f2e353"
    sha256 cellar: :any_skip_relocation, mojave:        "cdc6f7768fae60ca5c0eb1728f57533d008e420f125b8f0edcb093eea0309822"
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
