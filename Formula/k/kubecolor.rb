class Kubecolor < Formula
  desc "Colorize your kubectl output"
  homepage "https://kubecolor.github.io/"
  url "https://github.com/kubecolor/kubecolor/archive/refs/tags/v0.9.0.tar.gz"
  sha256 "2b2b9d845f5eadd025c16718c6f0e62557cc345fef1c036292c62f9473964301"
  license "MIT"
  head "https://github.com/kubecolor/kubecolor.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "b7fe7d1a4a1d479ce42cc03511c48693273ffd1b5671e25481a27e1bb7c6e4c4"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "b7fe7d1a4a1d479ce42cc03511c48693273ffd1b5671e25481a27e1bb7c6e4c4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "b7fe7d1a4a1d479ce42cc03511c48693273ffd1b5671e25481a27e1bb7c6e4c4"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "5e5b3d9ca4ea2bfe529582291123b8c08c114f4d8be41eecc9a8686a669975a1"
    sha256 cellar: :any,                 x86_64_linux:      "3233c0e081a96c4fdd3ba1e2705af45b1508a7bf7ddf954ff94840ba3fd5e8ef"
  end

  depends_on "go" => :build
  depends_on "kubernetes-cli" => :test

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-X main.Version=v#{version}"

    system "go", "build", *std_go_args(output: bin/"kubecolor", ldflags:)
  end

  test do
    assert_match "v#{version}", shell_output("#{bin}/kubecolor --kubecolor-version 2>&1")
    # kubecolor should consume the '--plain' flag
    assert_match "get pods -o yaml", shell_output("KUBECTL_COMMAND=echo #{bin}/kubecolor get pods --plain -o yaml")
  end
end
