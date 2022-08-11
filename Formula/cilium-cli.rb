class CiliumCli < Formula
  desc "CLI to install, manage & troubleshoot Kubernetes clusters running Cilium"
  homepage "https://cilium.io"
  url "https://github.com/cilium/cilium-cli/archive/refs/tags/v0.12.1.tar.gz"
  sha256 "8bba3eadd2ddde5b308f89302e53c37301dbac9131e1e1dedb86fe224556f4a5"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "72185c78391d4964dab94774ea522a401bc8507d727e397553638b93292307c8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "79b8b99f3821811484bcd9464afef1303f6b37a54e36ed1c6d44fb7485d7546a"
    sha256 cellar: :any_skip_relocation, monterey:       "40b8637e4cd5cb108e243df801676a3905aa41168eaceaf95f37e04c590e2d95"
    sha256 cellar: :any_skip_relocation, big_sur:        "00c9ccd99afa4180960a3029f229f9e0775bb06339caaf0ffc0650b7ab1c0ac2"
    sha256 cellar: :any_skip_relocation, catalina:       "b083b7421dd725e19c5454bc6711fc04f48a8443c74b2afe42640cb82763d504"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ea9d467a2d8f1c70d1c3c2f40dd231b81a233b5cfe1f962b82d5fa0e9fda448a"
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
