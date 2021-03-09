class Azcopy < Formula
  desc "Azure Storage data transfer utility"
  homepage "https://github.com/Azure/azure-storage-azcopy"
  url "https://github.com/Azure/azure-storage-azcopy/archive/v10.9.0.tar.gz"
  sha256 "902a88fdab6d7b9c59c2c74f8790bd5c68800b4722100aff6783179e1f8187da"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "334547fdc70fa41106d5114b76ab08493093afa617a82ce6cec40a091aa83596"
    sha256 cellar: :any_skip_relocation, big_sur:       "97e4067d47b318108d937db59f8aae494e9ddfb6be0998a5694b6c5f8655f23e"
    sha256 cellar: :any_skip_relocation, catalina:      "7b3140a4b4ebf47882e2e4aca83c60b535723efacc654573ae88b9d725f7e97a"
    sha256 cellar: :any_skip_relocation, mojave:        "9379775ca7e3c3776bc081957c17ce0f61bb1b9850c5af57a887d0a7b21c490c"
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
