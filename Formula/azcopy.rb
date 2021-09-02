class Azcopy < Formula
  desc "Azure Storage data transfer utility"
  homepage "https://github.com/Azure/azure-storage-azcopy"
  url "https://github.com/Azure/azure-storage-azcopy/archive/v10.12.1.tar.gz"
  sha256 "ac7e9ce94152e2e9c5c524a9b414d425debd8909fea545c53c377bec14eefe70"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "6c18f78533fe0b8addc11d8199d5d38d6b95b24987eecf4a14beecda3e782f2c"
    sha256 cellar: :any_skip_relocation, big_sur:       "7039b3e5e44cd361a1f53a79184670c9e1e0ef562fe222bac9deb68bddc56e8c"
    sha256 cellar: :any_skip_relocation, catalina:      "e3cf4275833ed6bd68a3e35da805792c28ef616dd43c5fef3d632677dfe72192"
    sha256 cellar: :any_skip_relocation, mojave:        "9eaa6e0b54ee9e9caa4891db9720224e5183a208a22e9b3b5e6d8fde05acec66"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9471284b0cf14e185d418e6d9ffe71e4722defe660596f774b42c4d7e3d818ab"
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
