class CiliumCli < Formula
  desc "CLI to install, manage & troubleshoot Kubernetes clusters running Cilium"
  homepage "https://cilium.io"
  url "https://github.com/cilium/cilium-cli/archive/refs/tags/v0.13.1.tar.gz"
  sha256 "4eeb6e38ef9ae7b320daf8bbdb312bb0dfcb4c535d9acd5560b69e71b2be413b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "539c2f6891fdefcf5473c8d349e716bff57f0a5f845fe096c5c228d2a9c74116"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ba2b4c663e28132cf3bf7eb0c10305ff3270419aac6824b884878002388a6fe9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "20ffa7bccc5617995353cd15c87d6a51f39ba9baa910a687b1b5ae7981c17d0b"
    sha256 cellar: :any_skip_relocation, ventura:        "2f6207c855ad275b1f8ad7658cd78ef1747f24d31a4122d1d510dd4d1de7cf26"
    sha256 cellar: :any_skip_relocation, monterey:       "100530c1d42e9215303f54cb24918cee53edfdbc75711ac527a24186081ec164"
    sha256 cellar: :any_skip_relocation, big_sur:        "738ffa3182845e1a25b8397d12fdfc228505155eda2360fe9145e97e6cd7a0e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "81bfac013bf22912d290399dfa8d32f6a29d677cfda9a3dd4b263bdfdd1c9bae"
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
