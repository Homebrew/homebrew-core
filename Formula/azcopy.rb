class Azcopy < Formula
  desc "Azure Storage data transfer utility"
  homepage "https://github.com/Azure/azure-storage-azcopy"
  url "https://github.com/Azure/azure-storage-azcopy/archive/10.3.4.tar.gz"
  sha256 "3a0a1450889af252ef251ae5bc86a145f3f77922d316947d7a90088fd1427619"

  bottle do
    cellar :any_skip_relocation
    sha256 "8a72a2b66b7351c5842549d66e5631cd2e64445d5879c614fad6618ef9a50ce1" => :catalina
    sha256 "59b7c6aded6ed98cdf911f89f2b1acec44a49999dfe9850351babbc45f8eb80d" => :mojave
    sha256 "c53dd2b636af6f83c2dbc35bee9fe74db71a9f9c895c492f2ca6138f427a3d46" => :high_sierra
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
