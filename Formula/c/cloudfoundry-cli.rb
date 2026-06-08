class CloudfoundryCli < Formula
  desc "Official command-line client for Cloud Foundry"
  homepage "https://docs.cloudfoundry.org/cf-cli"
  url "https://github.com/cloudfoundry/cli/archive/refs/tags/v8.18.3.tar.gz"
  sha256 "b1d752410595f21838eafe56887e57d31e1dd212db2d77137d606d5a85039bf0"
  license "Apache-2.0"
  head "https://github.com/cloudfoundry/cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?((?!9\.9\.9)\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f705e68a2959bb6c488ec8004069d167b00303ad4846006ffd624f840ab3321e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f705e68a2959bb6c488ec8004069d167b00303ad4846006ffd624f840ab3321e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f705e68a2959bb6c488ec8004069d167b00303ad4846006ffd624f840ab3321e"
    sha256 cellar: :any_skip_relocation, sonoma:        "53a17a7b1f10444d15e97f8e0ee993094cdbac64508f2daacffa0a9e9ec88df1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4fb78b418253c6cc5f330359e38429f6ca08669a17c437c164e125030fe2cf51"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "60c91c38748b0c3bd96c8e09c24f0e01b9bc7883a1e23994b1f5f83cd6d1d775"
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
