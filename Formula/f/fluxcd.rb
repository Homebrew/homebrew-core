class Fluxcd < Formula
  desc "Open and extensible continuous delivery solution for Kubernetes"
  homepage "https://fluxcd.io"
  url "https://github.com/fluxcd/flux2/archive/refs/tags/v2.9.5.tar.gz"
  sha256 "c8f59d1ad1cb3392a71286506cc8b3b0bf1ad1095c6e7c9a8d50a631f0736842"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "a8f7506b34b179ce2a1fc0e0d3dd41b199bdfa50051ac305cd6e9fafdb9b98d0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "4d8b3fcb09183d3a8cd1961fba73d6d41097aa7f79c12e21f5a4695d6fb641ba"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "5a4c2c6be6c8d88fc94809496e117bb71ba0d6e6a8932ab52a1ba087734faed7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "01de4113d17f1fd1ea6bda5e9d7f9d53afe066ac49a7fbd64a397c6dbe1b0d5d"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "2a0ddf9b31a12c8c90a0f3c08a4ac1fbf23d57b531f1b8de3b878f94e1e2c219"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "8b7c0b8e75546510a8d7145b4f32db900a7d95be44cb139996e2a97d37b4f1e5"
  end

  depends_on "go" => :build
  depends_on "kustomize" => :build

  conflicts_with "fantom", because: "both install `flux` binaries"
  conflicts_with "flux", because: "both install `flux` binaries"

  def install
    system "make", "build", "VERSION=#{version}"
    bin.install "bin/flux"
    generate_completions_from_executable(bin/"flux", "completion")
  end

  test do
    assert_match "connection refused",
      shell_output("#{bin}/flux reconcile source git test 2>&1", 1)
  end
end
