class FlowCli < Formula
  desc "Command-line interface that provides utilities for building Flow applications"
  homepage "https://onflow.org"
  url "https://github.com/onflow/flow-cli/archive/refs/tags/v1.20.4.tar.gz"
  sha256 "a79c4f8cef3b2525bdd9f47544b5333a2aaa286d140fa95ca9535094ecbfb41e"
  license "Apache-2.0"
  head "https://github.com/onflow/flow-cli.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "787fc92b62efb2f986b7977c263fc8adeec5be9ac92938d5127ae2eede8d405a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4d1ea27e20cb9e69475078903b0283d34f7a1b3d6f8608d509174fe42d77f0d7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "28847dd1612c0b617afde1a4c5ec3bf6d7c3f9fd76a7accb7bb5067e96a8ba74"
    sha256 cellar: :any_skip_relocation, sonoma:         "c7c537f257a0c4ba0d77dac41714c3e883d24b27c951a4f8debb265d87844aea"
    sha256 cellar: :any_skip_relocation, ventura:        "0e8526bd2bfc712a908dfe2b7078a64f932be3fe6c207697dbe0c4cfea40f044"
    sha256 cellar: :any_skip_relocation, monterey:       "a4109346390bc72ea1cfbc1abad14a63db024db3b27a3d3a1135fbf51351983f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "538d09c3205f119a2cd6fc91e4384f78d910dfa4006d715b3bed66b4ce611a11"
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
