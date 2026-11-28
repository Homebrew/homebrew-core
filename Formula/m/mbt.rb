class Mbt < Formula
  desc "Multi-Target Application (MTA) build tool for Cloud Applications"
  homepage "https://sap.github.io/cloud-mta-build-tool"
  url "https://github.com/SAP/cloud-mta-build-tool/archive/refs/tags/v1.2.53.tar.gz"
  sha256 "d4e24f95f17ae8826d398a429b015d4436d224840d99a7af7f061d9ed026aab4"
  license "Apache-2.0"
  head "https://github.com/SAP/cloud-mta-build-tool.git", branch: "master"

  bottle do
    manifest_sha256 "d4ebe41c92253c6f26ca6ecf99b7ceebc6e5c8aba16dd0f7ecbee9c74dec95de"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "ccc59495b37f88d6949c85be4ba132fe214f930e0f74588ac70d7656351d6d81"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "ccc59495b37f88d6949c85be4ba132fe214f930e0f74588ac70d7656351d6d81"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "ccc59495b37f88d6949c85be4ba132fe214f930e0f74588ac70d7656351d6d81"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "6f99decfba078400db0290928d66405efb71e106e2a03cae1401ed3f7eb20620"
    sha256 cellar: :any,                 x86_64_linux:      "b14644d0b56a6f73346d65a24f4ef5effa7ca6fe07b5bcff0193df171e82b5f4"
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
