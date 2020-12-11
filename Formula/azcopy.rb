class Azcopy < Formula
  desc "Azure Storage data transfer utility"
  homepage "https://github.com/Azure/azure-storage-azcopy"
  url "https://github.com/Azure/azure-storage-azcopy/archive/v10.8.0.tar.gz"
  sha256 "95866844ff1bb315879b2f1ef70f7076a4cae2391d289af474d75ee2ca3b023c"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "e7e61a0094f999e66b3cb8de7f8b685ef09bece82582d29e15a889958746f419" => :big_sur
    sha256 "7b6825301369f3ce389f4ac8296c233c8d52dee9111ebd2b0ed4565ea3b845e8" => :catalina
    sha256 "d75d3238cbe0a28be4c691ac15504952514314ab397c8c176341dc3af8f26657" => :mojave
    sha256 "8d956dbffe97616440509483bad507efec5c68ac7ad4f68827b4ff7e1ef8ca47" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args
  end

  test do
    assert_match "failed to obtain credential info",
                 shell_output("#{bin}/azcopy list https://storageaccountname.blob.core.windows.net/containername/", 1)
  end
end
