class CloudfoundryCli < Formula
  desc "Official command-line client for Cloud Foundry"
  homepage "https://docs.cloudfoundry.org/cf-cli"
  url "https://github.com/cloudfoundry/cli/archive/refs/tags/v8.19.1.tar.gz"
  sha256 "b8a84d34a355dca188ef546e51d374f54f1aa82c0165bdb5e8d7ad7ee15da774"
  license "Apache-2.0"
  head "https://github.com/cloudfoundry/cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?((?!9\.9\.9)\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "09bc518822fb9be04129814a51e11baa75fa2a44818993a1cfc2ba1d1460ac1e"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "09bc518822fb9be04129814a51e11baa75fa2a44818993a1cfc2ba1d1460ac1e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "09bc518822fb9be04129814a51e11baa75fa2a44818993a1cfc2ba1d1460ac1e"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "299182bf73121311c314c0f3cd8015da10846757e15fc51f660e422ed944cfd2"
    sha256 cellar: :any,                 x86_64_linux:      "9728bb9b94400a5feba1dbbcbd3fbca8a904e22d962059af902946ccabd7a563"
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
