class Mbt < Formula
  desc "Multi-Target Application (MTA) build tool for Cloud Applications"
  homepage "https://sap.github.io/cloud-mta-build-tool"
  url "https://github.com/SAP/cloud-mta-build-tool/archive/refs/tags/v1.2.52.tar.gz"
  sha256 "a6feddc8099b139ee9162335ea13d06962cb3686c55447fdb643322314c862be"
  license "Apache-2.0"
  head "https://github.com/SAP/cloud-mta-build-tool.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e6cbd3432090002793d32db20fa35c2e0c8f6cf4b1a68aafbc233bc9f4e6a431"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "e6cbd3432090002793d32db20fa35c2e0c8f6cf4b1a68aafbc233bc9f4e6a431"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "e6cbd3432090002793d32db20fa35c2e0c8f6cf4b1a68aafbc233bc9f4e6a431"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "7d439eb1e464d97b0c4fc0e3386fc22bd94c96cfe3665413a6602765d17715c8"
    sha256 cellar: :any,                 x86_64_linux:      "bcea7027b5e6dd3248a50276aa8412bb1ae86b10dd4d7fd1323b70c5c60ee3c8"
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
