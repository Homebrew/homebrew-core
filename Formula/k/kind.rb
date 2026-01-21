class Kind < Formula
  desc "Run local Kubernetes cluster in Docker"
  homepage "https://kind.sigs.k8s.io/"
  url "https://github.com/kubernetes-sigs/kind/archive/refs/tags/v0.31.0.tar.gz"
  sha256 "f4aaa1f572f9965eea3f7513d166f545f41b61ab5efeed953048bdcb13c51032"
  license "Apache-2.0"
  head "https://github.com/kubernetes-sigs/kind.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "294786a773053174dd0207abd9f19a9149e9104f6f4bd025e4922ef18056e77d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "294786a773053174dd0207abd9f19a9149e9104f6f4bd025e4922ef18056e77d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "294786a773053174dd0207abd9f19a9149e9104f6f4bd025e4922ef18056e77d"
    sha256 cellar: :any_skip_relocation, sonoma:        "8991293d714f2a97961a74aaa270d45c1368c8dee3570d54f3bf1533c98b6a99"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fefb317de154724a6bef983c1e50f1709bab098b3ff829fe4aacef141307529a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a0725c9f5c415c504480815ddacad100756f3cc90601ec8f8f96f28fe3730d61"
  end

  depends_on "go" => :build
  depends_on "docker" => :test

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin/"kind", shell_parameter_format: :cobra)
  end

  test do
    ENV["DOCKER_HOST"] = "unix://#{testpath}/invalid.sock"

    # Should error out as creating a kind cluster requires root
    status_output = shell_output("#{bin}/kind get kubeconfig --name homebrew 2>&1", 1)
    assert_match "failed to connect to the docker API", status_output
  end
end
