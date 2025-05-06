class Chaoskube < Formula
  desc "Periodically kills random pods in your Kubernetes cluster"
  homepage "https://github.com/linki/chaoskube"
  url "https://github.com/linki/chaoskube/archive/refs/tags/v0.35.0.tar.gz"
  sha256 "bc032ac1ce1abfe75f4cea17f23f15a1ac36b6669c99f123e7c1d4fbb6709921"
  license "MIT"
  head "https://github.com/linki/chaoskube.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "175ff90eee624e0fe6bb640a4645133925935cda6f0de21380af7c91bc5153e1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "72495e8d18d66656fad0d18f29a88e8f55d3ef37e89aa56bac24eafda7cf7f14"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "082ddd52530610338e1eb7f3f8fb0bac9ca5ca8c97e5f286a02d604a6a2a1d12"
    sha256 cellar: :any_skip_relocation, sonoma:        "74a0d120558a46523562a4faba1f824bb5d3779039afb5e615290a2e7ac02bb0"
    sha256 cellar: :any_skip_relocation, ventura:       "4e0f59315741696979c5145c7558e350e30f18748a870a2888fdfaf60a2a9119"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b23892e6e8ecfc587e7a7cbf8d974f4b8f05006312b4845eb07d97c5eeab3b63"
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
