class FlowCli < Formula
  desc "Command-line interface that provides utilities for building Flow applications"
  homepage "https://onflow.org"
  url "https://github.com/onflow/flow-cli/archive/v0.39.3.tar.gz"
  sha256 "e51d1db4c01147ca3f94c63c03d532c733055aa7bba608559700f3aac957a5f3"
  license "Apache-2.0"
  head "https://github.com/onflow/flow-cli.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4e4f6b9a471e6869d054495fd9d72fcbae23dfe0722564ca4e6bde6a5bdee288"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "edc6a0c078b73a01383f263d5f20710c32a243b803b7be7f7cd75e4594b98842"
    sha256 cellar: :any_skip_relocation, monterey:       "540134af7f9d7a3cfc543c29aaa0b8964e0929cc292b43036e36c6fcec70f165"
    sha256 cellar: :any_skip_relocation, big_sur:        "6e7157105d0bbcf91fa6447d8e5a597397ec05e952801f08a6fb5f423a528049"
    sha256 cellar: :any_skip_relocation, catalina:       "807a70c30385d78afc176f012f833d83a4e97088104e0104fc21910c0d78ccc5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "62b91cfe82381f09e105da07a28b54382cb7605a2088dd6d023ef5e4cab5c4bd"
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
