class Azcopy < Formula
  desc "Azure Storage data transfer utility"
  homepage "https://github.com/Azure/azure-storage-azcopy"
  url "https://github.com/Azure/azure-storage-azcopy/archive/v10.7.0.tar.gz"
  sha256 "cfdc53dd2c5d30adddeb5270310ff566b4417a9f5eec6c9f6dfbe10d1feb6213"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "18a2bd84e8497296777f093f9651c7ccfe981ed9c7ebc2d626b0c5da512c2466" => :catalina
    sha256 "4732f8449fc1c58f70b8436d09190445ab6574c033f83e97b5984674481c531a" => :mojave
    sha256 "7104cf9b26940cf776c9b28c2a79fbe146d85edf462a2eae31181954afe18e74" => :high_sierra
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
