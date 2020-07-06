class Azcopy < Formula
  desc "Azure Storage data transfer utility"
  homepage "https://github.com/Azure/azure-storage-azcopy"
  url "https://github.com/Azure/azure-storage-azcopy/archive/v10.4.3.tar.gz"
  sha256 "c363d22db83bd3549494c5e922918b245aeb29db024ab5b904d26b498292457d"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "009ce3db54395bb07c8938f63178495b39d933ffea7fb805023bab16e40361dd" => :catalina
    sha256 "3cf64d1335193e4083b9c430d9bdb4b611390a3e72df9f6ec62017860e888a01" => :mojave
    sha256 "975f0f8d7d078c307b95541882aebbe3d63240d140702b52594be021022cebf0" => :high_sierra
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
