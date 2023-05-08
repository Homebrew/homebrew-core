class CiliumCli < Formula
  desc "CLI to install, manage & troubleshoot Kubernetes clusters running Cilium"
  homepage "https://cilium.io"
  url "https://github.com/cilium/cilium-cli/archive/refs/tags/v0.14.2.tar.gz"
  sha256 "55121f5a074f540e96f8216f6e107499f57a11c279589400616d28971b0fe88b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4e90e343e8b58f9b936b77b07f823f71edac314b8756a3f19d03eb7b2eab80ee"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8b74d763f8810e58b3c8b68479ed4b594151bbe4507c8537a2f21523388b2593"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "23980a402047ceaec326b42970a04217b8bd8fc92b9ba0d94a06f8e24668e22f"
    sha256 cellar: :any_skip_relocation, ventura:        "02b73e88ea70bc1a848bf4d03f8382fdfea0e1892d9a27c1690daf26a7817580"
    sha256 cellar: :any_skip_relocation, monterey:       "06a51fe64cb6f6c9ea99911b700b02f9ca3e9707045df5ddc9af1b1d5a5eb0fa"
    sha256 cellar: :any_skip_relocation, big_sur:        "b67ade96f41a445de9c3548fc93b2fdafd820a37e6a0ff0618e84a4d7f10bb0a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "351233464b7a6e391446f2bc1697783d82324d10018e43a9242be1057779ee0b"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/cilium/cilium-cli/internal/cli/cmd.Version=#{version}"
    system "go", "build", *std_go_args(output: bin/"cilium", ldflags: ldflags), "./cmd/cilium"

    generate_completions_from_executable(bin/"cilium", "completion", base_name: "cilium")
  end

  test do
    assert_match('Cluster name "" is not valid', shell_output("#{bin}/cilium install 2>&1", 1))
    assert_match("Error: Unable to enable Hubble", shell_output("#{bin}/cilium hubble enable 2>&1", 1))
  end
end
