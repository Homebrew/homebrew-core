class Azcopy < Formula
  desc "Azure Storage data transfer utility"
  homepage "https://github.com/Azure/azure-storage-azcopy"
  url "https://github.com/Azure/azure-storage-azcopy/archive/v10.15.0.tar.gz"
  sha256 "f850ee5f3d45d3769d9929a98abc3d2b997e90ad4fd6dc49a487b248e6e8d78c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "97f26cdb3df37d27f65f77b64ef862d29b884eaa04dabcfa2b4a3d8a509cf57e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b1a913da9d85b46c741795d4b9ea255fd61f2565fce32434ab98431bfb3b464b"
    sha256 cellar: :any_skip_relocation, monterey:       "a3ab1514821876be2ecd9bdce87429c267c1dc612890d5426f84636b36d033c5"
    sha256 cellar: :any_skip_relocation, big_sur:        "197da9a3c6d6c2d1cb416b701fb1e44ba0139938348414aa7d754597d3eb9154"
    sha256 cellar: :any_skip_relocation, catalina:       "e1c09f720170be02e881e471a1eacf33ff5c243b91f41f83be004512d6e44da7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "78eaa8a81d24eb4c6dbdf77d668a10b0c0772db7b2a9750f12ff20c4c9f7cf8b"
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
