class FlowCli < Formula
  desc "Command-line interface that provides utilities for building Flow applications"
  homepage "https://onflow.org"
  url "https://github.com/onflow/flow-cli/archive/v0.42.3.tar.gz"
  sha256 "3c5a44ded1b458ba340f3df21c94565cae794c6ef1f67790ad1d764fb8864f08"
  license "Apache-2.0"
  head "https://github.com/onflow/flow-cli.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a8d3227b19d0733b4903545caef0383b09defd3caffe67fbbd85724a0878da7c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b47b1dce404ba061aa0d8689bc7d1cc980a528c8452eb9f12f23e3b8cf39dbb2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a867ca1d814b6b89b63ff5325cc64ac4abc39b3c5e64f21fcc9fd69d618a3b35"
    sha256 cellar: :any_skip_relocation, ventura:        "9199e32e91a60a7e41bf4417eb6d70100cd0b803ace7089206d4fd27a3b7ad65"
    sha256 cellar: :any_skip_relocation, monterey:       "eabaf27e8720e420a72521de4121651ef6d25af9cda30f2258c6e0e87610fadf"
    sha256 cellar: :any_skip_relocation, big_sur:        "1e5a9eb03c47b607d708bd741e0338d5a5519a6320ace62a8ebf8a3e82532459"
    sha256 cellar: :any_skip_relocation, catalina:       "9bd44f6d449ab8596b996ee7dcc66dcdbeaa1e398c854d496c097f2cbd715370"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "58124dca39f6e6531801be7c12bb9584cded9b55c4455825afc34530e22e7787"
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
