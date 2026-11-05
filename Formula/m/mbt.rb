class Mbt < Formula
  desc "Multi-Target Application (MTA) build tool for Cloud Applications"
  homepage "https://sap.github.io/cloud-mta-build-tool"
  url "https://github.com/SAP/cloud-mta-build-tool/archive/refs/tags/v1.2.51.tar.gz"
  sha256 "fce8f6d915693fffe6b0c1101391f8e145854ecc761b5d7001ec95e8043044eb"
  license "Apache-2.0"
  head "https://github.com/SAP/cloud-mta-build-tool.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "1d55c1126806cdfaa2b08e20fbc590621cfc083767231d3a66d4385315b5f3cb"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "1d55c1126806cdfaa2b08e20fbc590621cfc083767231d3a66d4385315b5f3cb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "1d55c1126806cdfaa2b08e20fbc590621cfc083767231d3a66d4385315b5f3cb"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "03997bc6ce70500b918a7a33e463d2fccf5719a270eaa24ef7c4a8b6ce3a98ea"
    sha256 cellar: :any,                 x86_64_linux:      "b7f699532be8d4ce24f6c88c122d6ff75847bf30335dcb2a018b8492f97dd121"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-X main.Version=#{version} -X main.BuildDate=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match(/generating the "Makefile_\d+.mta" file/, shell_output("#{bin}/mbt build", 1))
    assert_match("Cloud MTA Build Tool", shell_output("#{bin}/mbt --version"))
  end
end
