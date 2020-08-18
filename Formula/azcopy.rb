class Azcopy < Formula
  desc "Azure Storage data transfer utility"
  homepage "https://github.com/Azure/azure-storage-azcopy"
  url "https://github.com/Azure/azure-storage-azcopy/archive/v10.6.0.tar.gz"
  sha256 "2a35eb2ba69fd2f6d38bdd452ae5d585ef9401a1633287b1d44b14aa0269b0b8"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "adbe49aa62797ac82274548fee08827e4c6d85240bcd8e6f026f5165c5d1a3aa" => :catalina
    sha256 "8f6ffde86df2bf64e1ffd3712321d5c6f687bcafe892072020c8032f7533c402" => :mojave
    sha256 "8afa12a5d61c1fda453a61f182c18a8c4d4edb1b756875eaa416ed3f6c33bb9e" => :high_sierra
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
