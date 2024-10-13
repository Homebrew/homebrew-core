class Chaoskube < Formula
  desc "Periodically kills random pods in your Kubernetes cluster"
  homepage "https://github.com/linki/chaoskube"
  url "https://github.com/linki/chaoskube/archive/refs/tags/v0.33.0.tar.gz"
  sha256 "d41321fc6987a7f514ed7dda26e673de7ee2bebc67e9b5e2bddfbfbd8cc0065a"
  license "MIT"
  head "https://github.com/linki/chaoskube.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "e92683b4f12431a550bdc4fd1299ef39c04b8463421e24200fd91985d3c56be7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5bde91f9966a68b60d943663727e754b4f8d2c4d3fa6870b1bd2187b4c1e3152"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "acd027bcd3b8c0491a71a6302acf621a10e256d5dabc56784cccc4b6306b9dc3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bd33586e2a57198e2ab3878b2a199457eb0fcd594488b7fd8fba58000afd46f8"
    sha256 cellar: :any_skip_relocation, sonoma:         "d8dd1af39fca69a2f5742ecf2b4493e239f3cb4cefd5009d222a39aaf0110dc0"
    sha256 cellar: :any_skip_relocation, ventura:        "0d0faa2d5c1c39701d996c9f9120294b777b3a6b880fed27fde651ce8b801bbd"
    sha256 cellar: :any_skip_relocation, monterey:       "d86a512128cc9d89a884f8c0ec91f8e0edc695794f7ab2fdda493ecc914b5790"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "34b30206a384aca016c045209255ae8073e6f45b33081768eb1b43a17dd4890d"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    output = shell_output("#{bin}/chaoskube --labels 'env!=prod' 2>&1", 1)
    assert_match "dryRun=true interval=10m0s maxRuntime=-1s", output
    assert_match "Neither --kubeconfig nor --master was specified.  Using the inClusterConfig.", output

    assert_match version.to_s, shell_output("#{bin}/chaoskube --version 2>&1")
  end
end
