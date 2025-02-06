class Azcopy < Formula
  desc "Azure Storage data transfer utility"
  homepage "https://github.com/Azure/azure-storage-azcopy"
  url "https://github.com/Azure/azure-storage-azcopy/archive/refs/tags/v10.28.0.tar.gz"
  sha256 "5c2ef0d11193df1ef86e8f0478d3ea1155fec5d82130c9f43a169d9ee4f55369"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2a68d6d58f2ca9be17e6e893e98171629b4b281d36855982d8aa338a1608e155"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ea2239227ccc47ca0ae07a4e74f4a76f7dc0081f7394498e925e7427dfc545e9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4854c11122791fdcc1c399b48fc6334b0cb7e2a661e7ca13aad3ce9f31b263e5"
    sha256 cellar: :any_skip_relocation, sonoma:        "7a8a97c37f8c6f07823fd209eead8bcb4652146ecee9503a63fea303abd6e3fc"
    sha256 cellar: :any_skip_relocation, ventura:       "6df93eab8d12b38c94998224ba84429245d5174605dfff88f75a9dfa92d7ebb3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "44029ecaec0fdfc5b8a4bc2ad8cc33b3f1238f2e655644ef27b9e07ebea4fc47"
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
