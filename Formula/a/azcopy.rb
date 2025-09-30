class Azcopy < Formula
  desc "Azure Storage data transfer utility"
  homepage "https://github.com/Azure/azure-storage-azcopy"
  url "https://github.com/Azure/azure-storage-azcopy/archive/refs/tags/v10.30.1.tar.gz"
  sha256 "89d8b432d1d40e7bf85000c2a43c497d4cc27efcf223988e372b129473595441"
  license "MIT"
  head "https://github.com/Azure/azure-storage-azcopy.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a315dad4cf6846d40e6be1cc646bd3b13ab9661a7eff08aaed1fe39cf052ad40"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "25601eeb6499fb75ebeea147b2d7630d4b09dec998330dea8d5e93072b7858bd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "51605cf7f13b85ddafcf473fae410224d1a3201931422802113b4233f13a8417"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d3386d35767af29f2ae1058be87cc3d8ebddb287ea5293d6e0b63c7bac275ca6"
    sha256 cellar: :any_skip_relocation, sonoma:        "442b7f2da22b217879171edd95b0c6ebc1a3e8dd6cbb381548fb3987e9841fd6"
    sha256 cellar: :any_skip_relocation, ventura:       "a06b5734eedb9f1a83549664749eb7f14ce26c079311d14aa8304ec2f7d5d21f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a18300ef12a5635ae729798a5494528d6fd515ab8ebd6f1f25eb5273e166079e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2230c9d4e7e3ee7edf4df100a9e8311c871a5929fd36a981e72663722f46fbdc"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin/"azcopy", "completion")
  end

  test do
    assert_match "Existing Jobs", shell_output("#{bin}/azcopy jobs list")
    assert_match version.to_s, shell_output("#{bin}/azcopy --version")
  end
end
