class FlowCli < Formula
  desc "Command-line interface that provides utilities for building Flow applications"
  homepage "https://onflow.org"
  url "https://github.com/onflow/flow-cli/archive/refs/tags/v2.6.0.tar.gz"
  sha256 "35bce568c3091aff1e8200ecd055f80871ac6d965f7ee43c77bae1f1e0bfafc9"
  license "Apache-2.0"
  head "https://github.com/onflow/flow-cli.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8fd6894a5afef2de93eb1ce54589563c59a554713d7194ff00639526878772de"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7f5ac6cb2bee67c019e0c704a7bfc7824c81fa4cddc77563446288250f8a2d42"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a21771b18017a94fa495d642c3c058410cf0d698e6bb713f2efaa438bf298cbd"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "34cd9029e88a7ff7d1e865deb0cfafff561efb37d6695e6bc4b74aae156138ea"
    sha256 cellar: :any_skip_relocation, sonoma:        "f3f62722ba8d32ea6436ee1714cb515c65769d2cb5471326ee66687c9f9cb7a4"
    sha256 cellar: :any_skip_relocation, ventura:       "48387969b08b1cae56cef8c358d893a36d2b4948f24242f53fa0da6a0823ee91"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bc00b8ce4993a0b0bc0bb864ed319f498170de40e33a9f5e70caab0e4ae47df6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4d5830f8b1e7e058e2298682ddb6426fe10c6e5596b4fd163dbd2ac68406e26e"
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
