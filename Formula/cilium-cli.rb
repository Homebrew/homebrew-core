class CiliumCli < Formula
  desc "CLI to install, manage & troubleshoot Kubernetes clusters running Cilium"
  homepage "https://cilium.io"
  url "https://github.com/cilium/cilium-cli/archive/refs/tags/v0.14.7.tar.gz"
  sha256 "521f39c693fea2e466944f4f852b4b2f7ee2220befa0360181a2b959ca6c9045"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b40e1af7c45f9fa143690ef9a4c5451fa6f49782c381abb04d6210784b9d5077"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0724aa6f6b64c6f2e1d52f357cc0f66d168df129677c9ddfe0fd069fc2b4ad0e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "11f2043ffbfbdadbce639e239464830abd232f8a86adfba48c0e538dc3b70696"
    sha256 cellar: :any_skip_relocation, ventura:        "c0f36c605d5d42ebb0c63253fbcc9eb3eaa3054f278fe21b9eebcf88b65106ac"
    sha256 cellar: :any_skip_relocation, monterey:       "dac0584316fb7a4ab2a382caa42c34153daeaf248f2e16f39bd430aee29fae9c"
    sha256 cellar: :any_skip_relocation, big_sur:        "c72f94e6c0d93bcaddea8c618afdaf3856c5cf2545d2d79662f4ae43d9435851"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8857167ec64b010deefe3aba89228c28d01a13be8735ba778882b3ca36a796e7"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/cilium/cilium-cli/cli.Version=v#{version}"
    system "go", "build", *std_go_args(output: bin/"cilium", ldflags: ldflags), "./cmd/cilium"

    generate_completions_from_executable(bin/"cilium", "completion", base_name: "cilium")
  end

  test do
    assert_match("cilium-cli: v#{version}", shell_output("#{bin}/cilium version 2>&1"))
    assert_match('Cluster name "" is not valid', shell_output("#{bin}/cilium install 2>&1", 1))
    assert_match("Error: Unable to enable Hubble", shell_output("#{bin}/cilium hubble enable 2>&1", 1))
  end
end
