class FlowCli < Formula
  desc "Command-line interface that provides utilities for building Flow applications"
  homepage "https://onflow.org"
  url "https://github.com/onflow/flow-cli/archive/refs/tags/v2.17.1.tar.gz"
  sha256 "c5da87b0fe81b89e4ed5811d1f490a94655fbd300d7ac9a540b4193d16adc0e3"
  license "Apache-2.0"
  head "https://github.com/onflow/flow-cli.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8fad2127df23c89cabf1b48bb220af4641efbd7e91eb2fc028751bdef249a51a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3d2f867f1b1a4bf8d57a88caa7ea2faf960999cb621e8ba1173593ed658516ea"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2134c5ee84dda7c6e46bab90708b4e6acd34015bd52d83dbe5f41d112cccb2b2"
    sha256 cellar: :any_skip_relocation, sonoma:        "2680df0a615d102b06ce4f099356397056dfde1cff3c5a78625d9db1e30a9523"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c2da3186891ce10830024e69d90f4573310b3675515ca2508477f794715bea77"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6c81c31f08d4d45834be1a873db8b17488bacdf7dd41340ba165964a72a00e8d"
  end

  depends_on "go@1.25" => :build

  conflicts_with "flow", because: "both install `flow` binaries"

  def install
    system "make", "cmd/flow/flow", "VERSION=v#{version}"
    bin.install "cmd/flow/flow"

    generate_completions_from_executable(bin/"flow", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/flow version")

    (testpath/"hello.cdc").write <<~EOS
      access(all) fun main() {
        log("Hello, world!")
      }
    EOS

    system bin/"flow", "cadence", "hello.cdc"
  end
end
