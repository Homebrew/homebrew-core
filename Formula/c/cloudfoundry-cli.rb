class CloudfoundryCli < Formula
  desc "Official command-line client for Cloud Foundry"
  homepage "https://docs.cloudfoundry.org/cf-cli"
  url "https://github.com/cloudfoundry/cli/archive/refs/tags/v8.19.0.tar.gz"
  sha256 "bfbbb833c2727432e48d7b383ba749f6ca7e5c11c1377cc6cd22ddc802057d23"
  license "Apache-2.0"
  head "https://github.com/cloudfoundry/cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?((?!9\.9\.9)\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "893d1dc7db0a05f1f62d40c36fdfdeab963d3c7dc08bcf0a7968ff6a08cbd02d"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "6a89bbbc6fd61c7f5c1f791eab969b24325deefe1cfcce67d53251a3527593bd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "6a89bbbc6fd61c7f5c1f791eab969b24325deefe1cfcce67d53251a3527593bd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "6a89bbbc6fd61c7f5c1f791eab969b24325deefe1cfcce67d53251a3527593bd"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "7e4fd211e34340695a52e528d7444c5877b17785a84cd03ba0c766ca32f5b36e"
    sha256 cellar: :any,                 x86_64_linux:      "5584469a2e82862f3b7dcec5f5b7f3ce282532c60a6ded55ff48e5617ca950ce"
  end

  # TODO: unpin go@1.26 when go 1.27 is supported
  # ref: https://github.com/cloudfoundry/cli/issues/3851
  # `SermoDigital/jose` registers `crypto.Hash(0)`, which Go 1.27 `RegisterHash` panics on
  depends_on "go@1.26" => :build

  conflicts_with "cf", because: "both install `cf` binaries"

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
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
