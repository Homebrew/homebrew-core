class Azcopy < Formula
  desc "Azure Storage data transfer utility"
  homepage "https://github.com/Azure/azure-storage-azcopy"
  url "https://github.com/Azure/azure-storage-azcopy/archive/v10.6.1.tar.gz"
  sha256 "0cf28072d611828f722cf78766f2c1458121c088cfc67aac32fb807e0ad5cc1b"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "fafe2581acf992a8fddddcfa5a6ba85e9294964d8e8793567851f4434561c274" => :catalina
    sha256 "415e3931ff54ec4fb6b2dd5ff1225459b93e730d17a6ac2e943b89c8d1a1de12" => :mojave
    sha256 "3bea18c2192e8697b2490fd24477a65a681278aae3141b89d5fa03d4d13e76fa" => :high_sierra
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
