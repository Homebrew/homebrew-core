class CloudfoundryCli < Formula
  desc "Official command-line client for Cloud Foundry"
  homepage "https://docs.cloudfoundry.org/cf-cli"
  url "https://github.com/cloudfoundry/cli/archive/refs/tags/v8.10.2.tar.gz"
  sha256 "d156b908e959ffb3ce1d91a55e88f8b7c554e8c9b33190183757fc959785ee5a"
  license "Apache-2.0"
  head "https://github.com/cloudfoundry/cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?((?!9\.9\.9)\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b84b9fd93860fd4c4d27b10fc10163d83205bd38429a24c175c3ded3ffb28792"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b84b9fd93860fd4c4d27b10fc10163d83205bd38429a24c175c3ded3ffb28792"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b84b9fd93860fd4c4d27b10fc10163d83205bd38429a24c175c3ded3ffb28792"
    sha256 cellar: :any_skip_relocation, sonoma:        "47e77bc9bb5c30578845bd388e1c83950f8b99e97b92f1d7172d222ef9803659"
    sha256 cellar: :any_skip_relocation, ventura:       "47e77bc9bb5c30578845bd388e1c83950f8b99e97b92f1d7172d222ef9803659"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "81fb9d93f88926220f397c1f5ccbde22b9319e5a0f0d0845c9698970cff344c3"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X code.cloudfoundry.org/cli/version.binaryVersion=#{version}
      -X code.cloudfoundry.org/cli/version.binarySHA=#{tap.user}
      -X code.cloudfoundry.org/cli/version.binaryBuildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"cf")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cf --version")

    expected = OS.linux? ? "Request error" : "lookup brew: no such host"
    assert_match expected, shell_output("#{bin}/cf login -a brew 2>&1", 1)
  end
end
