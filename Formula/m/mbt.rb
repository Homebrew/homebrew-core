class Mbt < Formula
  desc "Multi-Target Application (MTA) build tool for Cloud Applications"
  homepage "https://sap.github.io/cloud-mta-build-tool"
  url "https://github.com/SAP/cloud-mta-build-tool/archive/refs/tags/v1.2.45.tar.gz"
  sha256 "2c808e7920691dfd0dbf3bab48f86b5aab57a936de5fc9086daf6a090fce18d4"
  license "Apache-2.0"
  head "https://github.com/SAP/cloud-mta-build-tool.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5b44380596b3206fc81a45de4a6fdbe474c26ad8a992605885ae7045bc3abba3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5b44380596b3206fc81a45de4a6fdbe474c26ad8a992605885ae7045bc3abba3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5b44380596b3206fc81a45de4a6fdbe474c26ad8a992605885ae7045bc3abba3"
    sha256 cellar: :any_skip_relocation, sonoma:        "cf1ca2608fc2473a229983b40ea653eed3f69dd5fd97cf5337ee5488e4d1ad68"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e7a248614a6dad8253525537b10cca4b83ebf28f8a02e3f13fbe9471fcd4e553"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9faaf010089663b23d04307f3886af2712a0e9662486ef2778f1d9d746e7bf4e"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.Version=#{version} -X main.BuildDate=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match(/generating the "Makefile_\d+.mta" file/, shell_output("#{bin}/mbt build", 1))
    assert_match("Cloud MTA Build Tool", shell_output("#{bin}/mbt --version"))
  end
end
