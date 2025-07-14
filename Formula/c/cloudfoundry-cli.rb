class CloudfoundryCli < Formula
  desc "Official command-line client for Cloud Foundry"
  homepage "https://docs.cloudfoundry.org/cf-cli"
  url "https://github.com/cloudfoundry/cli/archive/refs/tags/v8.14.1.tar.gz"
  sha256 "231cdb5c10615447b122b605ff2280d734dc6d8dd82f559287415813448f70f2"
  license "Apache-2.0"
  head "https://github.com/cloudfoundry/cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?((?!9\.9\.9)\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "040d4b8bcc2b715e55c2c12259010504c5bf169a1502a3080e268ad0ca1a11bc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "040d4b8bcc2b715e55c2c12259010504c5bf169a1502a3080e268ad0ca1a11bc"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "040d4b8bcc2b715e55c2c12259010504c5bf169a1502a3080e268ad0ca1a11bc"
    sha256 cellar: :any_skip_relocation, sonoma:        "00ad7b993423c6e8505ca1f02b5c883c762557a072817afa5429bd4e66e7267a"
    sha256 cellar: :any_skip_relocation, ventura:       "00ad7b993423c6e8505ca1f02b5c883c762557a072817afa5429bd4e66e7267a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c498a547bb200f0950495d1f7bf1466c5fce72c111ab78510e39462669274f9b"
  end

  depends_on "go" => :build

  conflicts_with "cf", because: "both install `cf` binaries"

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
