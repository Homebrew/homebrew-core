class FlowCli < Formula
  desc "Command-line interface that provides utilities for building Flow applications"
  homepage "https://onflow.org"
  url "https://github.com/onflow/flow-cli/archive/refs/tags/v2.8.1.tar.gz"
  sha256 "00f476223008932fd002449246af7ceb8d008ce0667848a96136bfb6edfc34f6"
  license "Apache-2.0"
  head "https://github.com/onflow/flow-cli.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "68df6de8fd433569e00f3259df1682f3f5bc6a982e2a1b608a9377a53fcfbfb2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c06f369353d2d014dd835af9da879c920160ac9b65f3a293499465444f799156"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ea2ba98c955fef0445c7fd4a3fddc7390a0e6f8b4f90b1875f4477f5b7aa3d65"
    sha256 cellar: :any_skip_relocation, sonoma:        "06600cdee11a3d9a60d7d3f86a00926fd13d05e04db3528b918e4aa117dfbdec"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "27ff8d94784dc97aac8fd6993672373ed9188b9581611f943e87acf492e678f2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "60272a350a7ab29ad4fb6dd7a6550d650dd2939984cbfbc21fa1661e54124d48"
  end

  depends_on "go" => :build

  conflicts_with "flow", because: "both install `flow` binaries"

  def install
    system "make", "cmd/flow/flow", "VERSION=v#{version}"
    bin.install "cmd/flow/flow"

    generate_completions_from_executable(bin/"flow", "completion")
  end

  test do
    (testpath/"hello.cdc").write <<~EOS
      access(all) fun main() {
        log("Hello, world!")
      }
    EOS

    system bin/"flow", "cadence", "hello.cdc"
  end
end
