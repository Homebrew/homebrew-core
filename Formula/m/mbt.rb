class Mbt < Formula
  desc "Multi-Target Application (MTA) build tool for Cloud Applications"
  homepage "https://sap.github.io/cloud-mta-build-tool"
  url "https://github.com/SAP/cloud-mta-build-tool/archive/refs/tags/v1.2.43.tar.gz"
  sha256 "b93baa727ed23f06f5e36f10e3f7dffc0a6950dd9238921163dac80a4d91d94a"
  license "Apache-2.0"
  head "https://github.com/SAP/cloud-mta-build-tool.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "311d8eb5123a3aea5fbdf32976abfa895b646419d2eca32684b744aab5559c81"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "311d8eb5123a3aea5fbdf32976abfa895b646419d2eca32684b744aab5559c81"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "311d8eb5123a3aea5fbdf32976abfa895b646419d2eca32684b744aab5559c81"
    sha256 cellar: :any_skip_relocation, sonoma:        "2fcfad38f3da1b077e469a44b13a93c7851f20c06e8ec5fc9ee77cb3b4f949b7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d6dbf3a587e8d21a6777f0798e523950c7285208927a147da9cbc7a0615ffc8f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cc414a4dc5df5fd9f1929201bb3ab02c4cf36faee99919bbffcfd2df1fb21c6c"
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
