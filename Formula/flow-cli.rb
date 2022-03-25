class FlowCli < Formula
  desc "Command-line interface that provides utilities for building Flow applications"
  homepage "https://onflow.org"
  url "https://github.com/onflow/flow-cli/archive/v0.32.3.tar.gz"
  sha256 "7097e5381c4807b7ba4368ba398c995de6ae5e994abf178ffb22836bab42e2e9"
  license "Apache-2.0"
  head "https://github.com/onflow/flow-cli.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d0f67be85dad712fbed74c620f5dbd1e901cdcc09610c6ddf656d713d1129f30"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "213303f58edeeb40ff028b0e551074d850731de133e94796d08bc9b988d41bd8"
    sha256 cellar: :any_skip_relocation, monterey:       "e3856b31b721bf36ca7ca998b31bffa08335222975ec29fa6070e83c8e86baa6"
    sha256 cellar: :any_skip_relocation, big_sur:        "4a1fa2f536ca7abe8879ea0235d49e93a1e80fc3cb38c0ef9f6f78313da2800b"
    sha256 cellar: :any_skip_relocation, catalina:       "03e7f08b1cad84d5390441840fc7fa9cb373eb3dc35ca4ae4229fdfdcbb30761"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7d59f2b5e16964e9c37361b6ad54ad2b612760e28581fcc559f9d4b88d65bcbf"
  end

  depends_on "go" => :build

  def install
    system "make", "cmd/flow/flow", "VERSION=v#{version}"
    bin.install "cmd/flow/flow"
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
