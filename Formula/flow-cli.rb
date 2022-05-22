class FlowCli < Formula
  desc "Command-line interface that provides utilities for building Flow applications"
  homepage "https://onflow.org"
  url "https://github.com/onflow/flow-cli/archive/v0.34.0.tar.gz"
  sha256 "7ad63eef7ef9dce8fa4b53778c6c8bf7b14fa7dcfddb9b1f8fa1fa9ec1f60f80"
  license "Apache-2.0"
  head "https://github.com/onflow/flow-cli.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0dd733a32866caf3cc763db18a05d2568632a13dfdb9a6ec44e8782f1486b989"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ad6af85cd659a78bed832b29e0f996ad9aab421c1dfdd74cd75b62a9954fb8c8"
    sha256 cellar: :any_skip_relocation, monterey:       "a732b0b3f7122966f56583a2724514683c4c9874d809e1206a823ccdb9976f57"
    sha256 cellar: :any_skip_relocation, big_sur:        "a7ec1f24f6e3ad506b672b98e26dc800a156e034725e7a9e47f207696444bb59"
    sha256 cellar: :any_skip_relocation, catalina:       "7d11dde77b96d4a924e40dc4421bee1b9b48d8b3e8f2eb7d6d37ea551d632981"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "271b695ca7a3d1bb8a2a4aea017827957a401cda8dd5f918ee44a3bc1c0d5a7a"
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
