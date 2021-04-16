class Azcopy < Formula
  desc "Azure Storage data transfer utility"
  homepage "https://github.com/Azure/azure-storage-azcopy"
  url "https://github.com/Azure/azure-storage-azcopy/archive/v10.10.0.tar.gz"
  sha256 "6018cd8728344eea57ee99ed6875c6b088947dcb8539c59a4e72260df10e0fbc"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "6de1123c7e65b5d895f8a75b3fdec4fa6ec0a2f186d88d24d294454cc8a67e9b"
    sha256 cellar: :any_skip_relocation, big_sur:       "a1209b5036d3931d64c5039667a7f34e00b3f8c0dcd54ca07e68545ecf25dbe7"
    sha256 cellar: :any_skip_relocation, catalina:      "742bd1595080b20b83c042320e7d009e260daa42f9af10250c3817a2bac57e37"
    sha256 cellar: :any_skip_relocation, mojave:        "43775ba24e0083f7a9cbc8bc588c0185fc3e10f93b08b2c57144fe415a167895"
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
