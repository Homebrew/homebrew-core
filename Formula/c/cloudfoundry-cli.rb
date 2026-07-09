class CloudfoundryCli < Formula
  desc "Official command-line client for Cloud Foundry"
  homepage "https://docs.cloudfoundry.org/cf-cli"
  url "https://github.com/cloudfoundry/cli/archive/refs/tags/v8.18.4.tar.gz"
  sha256 "1371bedf6c3929d018edb18608634888c0e7a89f6d27faad24ce8bde25e91106"
  license "Apache-2.0"
  head "https://github.com/cloudfoundry/cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?((?!9\.9\.9)\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1d44610a8098f5a91af4964dfd33b93a2e190e4456b2aefe62818449a968e535"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1d44610a8098f5a91af4964dfd33b93a2e190e4456b2aefe62818449a968e535"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1d44610a8098f5a91af4964dfd33b93a2e190e4456b2aefe62818449a968e535"
    sha256 cellar: :any_skip_relocation, sonoma:        "1b3a7d679f59a3bed6016a527aa9f553305e79bc0b5f6173a9a3df7e1c02b36f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e4499c4b10b932185d59ee6b9ad92f0107cc12cfcbd16dfb9c784e1cc5f2d504"
    sha256 cellar: :any,                 x86_64_linux:  "3301f2ecf831019db6ad3f9a08777eff0c3893ed0d383065b1d0eac884f6bade"
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
