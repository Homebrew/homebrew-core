class FlowCli < Formula
  desc "Command-line interface that provides utilities for building Flow applications"
  homepage "https://onflow.org"
  url "https://github.com/onflow/flow-cli/archive/v0.44.0.tar.gz"
  sha256 "35d7167886a74413f66e38b1ad54fbc517b22f9a5b7bdc3e07aa425cd26b46c8"
  license "Apache-2.0"
  head "https://github.com/onflow/flow-cli.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "98c6297b229767aef85b307f63efb4c8a4b571607ccb6ee0dd8bf9aff67ee18c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5d505e9dfaa8411c7476fd918f85e6cf252c8a25cb3a880055b94b120a79f529"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b508ebb84a8ed6477988998b9a3c6142ec5f2a8834ff3ad019b0912d9d31b869"
    sha256 cellar: :any_skip_relocation, ventura:        "1296ccacaefc723839feb9bbfd8642dd33834e944971aab6806fa2c6c47b2d69"
    sha256 cellar: :any_skip_relocation, monterey:       "5a1b49a0829d459ef15c54db97442bba7b419acaf4947e030cf5e0a6efe99875"
    sha256 cellar: :any_skip_relocation, big_sur:        "b1b5fac39a309522fa712e505ad138e8f9ec0d4892ff849532e4cec061eec940"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bfa5c5427dd41eba06d23a84f0af0757afe10afe643ee4265006b1864e57f79b"
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
