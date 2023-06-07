class CiliumCli < Formula
  desc "CLI to install, manage & troubleshoot Kubernetes clusters running Cilium"
  homepage "https://cilium.io"
  url "https://github.com/cilium/cilium-cli/archive/refs/tags/v0.14.6.tar.gz"
  sha256 "64349f0ba84b0ef9f0e69398963a5cc6dcb127c568d2100901a5cddcb378fe41"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ad54404ccb22b33e168d798f2f0ab91cb3a539bab9f40a23f4b6372c57366003"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "76ead97a7787d5994a977ea5637d0cba846b11e4da1659226b01791c19983b08"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "997c7be4269e396b5e7d21e0899a3b3fd4f2864dcf45c8e56beff5b227ad1f73"
    sha256 cellar: :any_skip_relocation, ventura:        "53b58bbe7a6a638e89513b84ae706ff73717ecc4b6849dcee171d29698b0be59"
    sha256 cellar: :any_skip_relocation, monterey:       "aa3315fd5f7139ff140dc60dfac0f856d3df641464ab5a2291ba39aee0233005"
    sha256 cellar: :any_skip_relocation, big_sur:        "65f9c89e87cb92b81f0e90c167f22c1c98e4b466700e8f5556d6797ba761f6e5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9b9e6387f7a9c7bc2efaf077cd4587cceae310495de6f1ccf490135ea4eb249e"
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
