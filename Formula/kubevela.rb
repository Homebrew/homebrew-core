class Kubevela < Formula
  desc "Application Platform based on Kubernetes and Open Application Model"
  homepage "https://kubevela.io"
  url "https://github.com/oam-dev/kubevela.git",
      tag:      "v1.1.8",
      revision: "066c448c1ae5a339e4f8dfc17b60085f137e9de4"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "89a45a3ddeb349b19b00e13dd10c330a16b5cfaee1c59b5ff2fc0f2e9845a172"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "63897a419d79ef4b66afa0f635507766ed63b90660b8ae2e4ac4d3eec07da080"
    sha256 cellar: :any_skip_relocation, monterey:       "ac2c3e50533d537c73dda62b283bcd93ec8e82a8c533903dcdcba2b7032e7d6f"
    sha256 cellar: :any_skip_relocation, big_sur:        "4dcb0717494a844f63a55d7e26413197b694169be98bb0b6459f38c703fc50b2"
    sha256 cellar: :any_skip_relocation, catalina:       "905bc8864bdd727fb9a223490dd2e47af8d58a8f00e6a8fa3b32b0dd323ff409"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3b48f6466de06dac30df14811aa01e815ec9c1c8e5ad48bb58a42880fc1c36f6"
  end

  depends_on "go" => :build

  def install
    system "make", "vela-cli", "VELA_VERSION=#{version}"
    bin.install "bin/vela"
  end

  test do
    # Should error out as vela up need kubeconfig
    status_output = shell_output("#{bin}/vela up 2>&1", 1)
    assert_match "get kubeConfig err invalid configuration: no configuration has been provided", status_output
  end
end
