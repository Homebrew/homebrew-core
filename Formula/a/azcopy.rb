class Azcopy < Formula
  desc "Azure Storage data transfer utility"
  homepage "https://github.com/Azure/azure-storage-azcopy"
  url "https://github.com/Azure/azure-storage-azcopy/archive/refs/tags/v10.28.1.tar.gz"
  sha256 "b7b8f45e3f74a77d7317be2e06e067beaa71c02d0a3f66b5267e24beb59b1e3d"
  license "MIT"
  head "https://github.com/Azure/azure-storage-azcopy.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cb0c2aa67be7924bb6bdc1ee6cdab654a2cf787b791dbb0ee1f1f822acf1aef3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3206d65dc8f388b64b8e61f850dc64cd4aeaadded29c6019ff0095644493b5a4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5207c3aeef9d22896546555acb34be7d2c4da95005c423766dc5b3daea4204d2"
    sha256 cellar: :any_skip_relocation, sonoma:        "25e30694e68e810c91aa05908efb25f7665eb8453a03f08777eb4d4737e66025"
    sha256 cellar: :any_skip_relocation, ventura:       "235a52c172d11f8f0798fbda05244e00edc5eb806a4a488a781cb8b18541b211"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e6c6cedff923d021af69fb5c6ff92c4b1eb1de2a56193a82d0f0b4cc586798d5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5845d0f34ded6aa84c937811d584c7ca156c58b7d8dc9808c96714f67fdf40cb"
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
