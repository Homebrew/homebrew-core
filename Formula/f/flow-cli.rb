class FlowCli < Formula
  desc "Command-line interface that provides utilities for building Flow applications"
  homepage "https://onflow.org"
  url "https://github.com/onflow/flow-cli/archive/refs/tags/v1.7.1.tar.gz"
  sha256 "45a5a95628cc11f7befec3ca54d73d2df59e5fac0eb07be12b3c6e85606d02f8"
  license "Apache-2.0"
  head "https://github.com/onflow/flow-cli.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ba11f523b68776ddf9adea7bcc54106d7680c44adf7bed1fd36676c9db4aab23"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "44fb1d6a6b71e075a579bbfdc77e653ff2f36db033a0b528ccc2edbce2ff5564"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6e089297602745bc4ab1ec448bd63d866cbb11d1375aa7dcd5ae1575e326b562"
    sha256 cellar: :any_skip_relocation, sonoma:         "c597e938bf1f70277c94d86974feeac5abed5bee21765e2addcdba1d9157396c"
    sha256 cellar: :any_skip_relocation, ventura:        "eab59f37cbec381f3c841db903bf626131ea9de4325c22cfd43cc7b236604218"
    sha256 cellar: :any_skip_relocation, monterey:       "2c4cf5b1681ca323eddbd9c325af5d46b182ee1491b528ee621e7e74dea1a7e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "61d108bfcd8b16be069ab4c5da14cd58020972c42ba92764f17a14dea4d7ee8b"
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
