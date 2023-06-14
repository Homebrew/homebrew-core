class FlowCli < Formula
  desc "Command-line interface that provides utilities for building Flow applications"
  homepage "https://onflow.org"
  url "https://github.com/onflow/flow-cli/archive/v1.2.0.tar.gz"
  sha256 "14add0a2a24581173f222b37ba541e605eccaa71c75f65493134d5f857c8485b"
  license "Apache-2.0"
  head "https://github.com/onflow/flow-cli.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "21fda8c799fa0645b40b8af13c7d32722f25a76ab4bce697d2f853d4d8efd0e6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d71c914247eacdc6d12e8fa6e0e2b8be4b4d43af933911d8f85e3400ee4a460a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ffd28e7045fa13d1100449a00bb220dc32cd0cc9e3744208cbcab691aca58164"
    sha256 cellar: :any_skip_relocation, ventura:        "07544d4611e702bd00b46412ca0899bd39e7a2227c506030ab1f802acabb62ff"
    sha256 cellar: :any_skip_relocation, monterey:       "83abdf4477496c38f62a436f075efdfb3bcd36e30fb50df7fc83beaeda39b10a"
    sha256 cellar: :any_skip_relocation, big_sur:        "0ebf256b2fe58dcc39a684b3ce4065bf2562aa6fce29aeeb1fb91f0f88a6a3b2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bcdd36e81ddcc82b3d72c0e17c9274d220481172021ab0a995e5273df25ede6b"
  end

  depends_on "go" => :build

  def install
    system "make", "cmd/flow/flow", "VERSION=v#{version}"
    bin.install "cmd/flow/flow"

    generate_completions_from_executable(bin/"flow", "completion", base_name: "flow")
  end

  test do
    (testpath/"hello.cdc").write <<~EOS
      pub fun main() {
        log("Hello, world!")
      }
    EOS
    system "#{bin}/flow", "cadence", "hello.cdc"
  end
end
