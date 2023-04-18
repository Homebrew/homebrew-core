class FlowCli < Formula
  desc "Command-line interface that provides utilities for building Flow applications"
  homepage "https://onflow.org"
  url "https://github.com/onflow/flow-cli/archive/v0.49.0.tar.gz"
  sha256 "de5326427c0c9c7daca29f904f41229567e2fd8075dca24c5e2422dfd94b0808"
  license "Apache-2.0"
  head "https://github.com/onflow/flow-cli.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a0fee1cefa7fc174dbb37d5e65b360049c904eebcb3ae00e8b6dffdb7eef2779"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "726e448d44704aa9078dd925ab68196f75d0f55185697357e0ddaf26e3722ba6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "85dd37c4c030e79c8f5292e54a8f06c108e1139706e56dd5829e840458ff9359"
    sha256 cellar: :any_skip_relocation, ventura:        "928058d1542189be999759f600367ab2ea3de7854202fcc2a0306ce944694357"
    sha256 cellar: :any_skip_relocation, monterey:       "8be66569251719176ce3c1c5d5fbb57384c35611e60901066cbf2e541f5053ed"
    sha256 cellar: :any_skip_relocation, big_sur:        "5323c5e04749174b88ac15cae1bbf27e54b5faa4f29af1ea6622ca4cfcc99951"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "61091bc1e977d24af6631963c122bf6841d1645267478298f4394a60992c608f"
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
