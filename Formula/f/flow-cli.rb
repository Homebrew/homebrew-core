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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7dd5aae83cfb5fd57ade99b4eadc50bc950baa655ac22cb16ed55daaae557257"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f5840420b340d381a923eeeb5e9a96da820d895bc9f7365a2acf558eb7e58fbb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cbba121fe39353037fd77496603f0975a6e355842f8e40a3a773ea29e9656e59"
    sha256 cellar: :any_skip_relocation, sonoma:        "a1486af544e8a7a6df0a5706d8112e658aecb510def278551d580fa3f0abb9d2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "95dfdf3e412ea7a9a67472687f4875b95081115af6191dbc25f4797ad61623c7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7285ce2286027e1413e0a9a8409b3065351d38bea6ca022fb89ed40422f8a6a9"
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
