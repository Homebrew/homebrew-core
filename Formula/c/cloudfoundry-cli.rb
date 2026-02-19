class CloudfoundryCli < Formula
  desc "Official command-line client for Cloud Foundry"
  homepage "https://docs.cloudfoundry.org/cf-cli"
  url "https://github.com/cloudfoundry/cli/archive/refs/tags/v8.17.1.tar.gz"
  sha256 "4d837eee0fb92973eaa81dd7203ed6ff2b8e38b1e20e344dc5ac3dbd7705fc60"
  license "Apache-2.0"
  head "https://github.com/cloudfoundry/cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?((?!9\.9\.9)\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8a63d830b3324832d6ed7a0f9e237feb3aca296aae4b7d33d34a1489eddede10"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8a63d830b3324832d6ed7a0f9e237feb3aca296aae4b7d33d34a1489eddede10"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8a63d830b3324832d6ed7a0f9e237feb3aca296aae4b7d33d34a1489eddede10"
    sha256 cellar: :any_skip_relocation, sonoma:        "c5cdf00511346687c79f20f900c50b8ce2c418ad60dee22445031cade29c74ba"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "58ebe030da90e20a3ed6ab3fac90add37c347375ee26ae265181a77c558a2b82"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "36a6cfd82f7efc971882531e9cdf86302f1761e40882fbe2810cdeef74276192"
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
