class FlowCli < Formula
  desc "Command-line interface that provides utilities for building Flow applications"
  homepage "https://onflow.org"
  url "https://github.com/onflow/flow-cli/archive/v1.1.0.tar.gz"
  sha256 "649a0d30c2587bbf46fc64b8989e97f2c39ca54bc0603e01ccfc8177938db20f"
  license "Apache-2.0"
  head "https://github.com/onflow/flow-cli.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5c2ec6620b85899fd841f442e92fde216bab795499e1ce5ed596ff4048ea60d4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "848027a0d89ccf3d9ebc0dd4fe79a8180bad73df7f395275b8753e390612817d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "be2f20a2d21bedba0dd82d33f99d90f7c151060e2952ffe0a82f911807e4d497"
    sha256 cellar: :any_skip_relocation, ventura:        "d56c2d90fb6c4e029356acceeb56a6db0931a4122e4ae0988f22135f362768a1"
    sha256 cellar: :any_skip_relocation, monterey:       "126a38593002d1a34d0187b6d414b249fd6ab89375881f1790d04850407fd3e5"
    sha256 cellar: :any_skip_relocation, big_sur:        "6426e3d9215d9cf54c3dec1b980c9bc52257204958cab80909612831df7fac72"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5cd9b16b2a420a6f2af5a33af9648e3d1398274501885d7542fba97b07442d85"
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
