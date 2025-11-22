class CloudfoundryCli < Formula
  desc "Official command-line client for Cloud Foundry"
  homepage "https://docs.cloudfoundry.org/cf-cli"
  url "https://github.com/cloudfoundry/cli/archive/refs/tags/v8.17.0.tar.gz"
  sha256 "301bbbdab2477b594123a4ca74171d2ea9fa4c372aec2fd63b420ddb25e9717e"
  license "Apache-2.0"
  head "https://github.com/cloudfoundry/cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?((?!9\.9\.9)\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "674b5b9e9b95dba24ecd27c487b160347e2d9c84fe50913fcff7e458840cda3d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "674b5b9e9b95dba24ecd27c487b160347e2d9c84fe50913fcff7e458840cda3d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "674b5b9e9b95dba24ecd27c487b160347e2d9c84fe50913fcff7e458840cda3d"
    sha256 cellar: :any_skip_relocation, sonoma:        "7120ce545da7e68b3fef4e739f160e724bb4c7c05fb43f436dedafe5c78578e4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a1a738c4d5845bbc7a42b19d7e84c7508dc5c31784311ce7f37a1502b6bf9a34"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7ef28e4add7c64926e1bf02a888229bcf96395ecb488a4a6905cec0c4e0dc1a0"
  end

  depends_on "go" => :build

  conflicts_with "cf", because: "both install `cf` binaries"

  def install
    ldflags = %W[
      -s -w
      -X code.cloudfoundry.org/cli/v8/version.binaryVersion=#{version}
      -X code.cloudfoundry.org/cli/v8/version.binarySHA=#{tap.user}
      -X code.cloudfoundry.org/cli/v8/version.binaryBuildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"cf")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cf --version")

    expected = OS.linux? ? "Request error" : "lookup brew: no such host"
    assert_match expected, shell_output("#{bin}/cf login -a brew 2>&1", 1)
  end
end
