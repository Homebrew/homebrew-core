class FlowCli < Formula
  desc "Command-line interface that provides utilities for building Flow applications"
  homepage "https://onflow.org"
  url "https://github.com/onflow/flow-cli/archive/v1.1.1.tar.gz"
  sha256 "61286d7541a318bcb4a0cdf9efa3a567eb728069bf715033b9f4ed12e2db4012"
  license "Apache-2.0"
  head "https://github.com/onflow/flow-cli.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "eb24ed1bfcb4a6621b8d2965b96cb720a486523c57e1e1ea500251cbfae5c682"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fb9a9fe56c37479e72c3e7d497be0f58aec771c49cf77e0326551c70fcc3664c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cd3c77587a239573b42f66c6a9323f9f7778e668faf762c5d5e37b02750e1902"
    sha256 cellar: :any_skip_relocation, ventura:        "deb63d9e9296205d075001c48d85f1ae034ea07e55381d827fa5c1cc95238be5"
    sha256 cellar: :any_skip_relocation, monterey:       "2aa6a4d5b9052efb5189fa6016642f990b53bc4d2ce2664fb61450893b216141"
    sha256 cellar: :any_skip_relocation, big_sur:        "2652927acf3c5819583dd1195aa63f2f58fe26d7896ed0410945c0cb453e357d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "65f7cdd41ecb9005871fbc2c41ad33c07246c95b701ecb075b9b1fa80a5fc81b"
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
