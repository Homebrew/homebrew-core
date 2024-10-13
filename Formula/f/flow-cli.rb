class FlowCli < Formula
  desc "Command-line interface that provides utilities for building Flow applications"
  homepage "https://onflow.org"
  url "https://github.com/onflow/flow-cli/archive/refs/tags/v2.0.7.tar.gz"
  sha256 "eefd13985412097a561a86b7ad642f733e4d7fc27e86809f429adcdfa1c77b0d"
  license "Apache-2.0"
  head "https://github.com/onflow/flow-cli.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5e77a0400cf9a0e612fe0bc3ef76c23a9e03bc320b9699fd7eb5267d12662575"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6e9d4dd9ab2819519da286c4a24369befe0a974cb780b34a0a1ed95cd93d2dda"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d61ec0ad332325c552dda1b9012b1bb6006172d1a124f35bd4fff1bca1e29257"
    sha256 cellar: :any_skip_relocation, sonoma:        "8d6a8a6aa73b951ea2d557a39054d76ed03a842b742eeee0d10ca858c0dd6725"
    sha256 cellar: :any_skip_relocation, ventura:       "2e81f71b5355b020f00862cce0bb1d7be0f658b71008801603ac5e5336b9ac17"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2b2622e5da397a7e7616e796f1097ffc794ca48ba64d3ad49493ce6a838f421f"
  end

  depends_on "go" => :build

  conflicts_with "flow", because: "both install `flow` binaries"

  def install
    system "make", "cmd/flow/flow", "VERSION=v#{version}"
    bin.install "cmd/flow/flow"

    generate_completions_from_executable(bin/"flow", "completion", base_name: "flow")
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
