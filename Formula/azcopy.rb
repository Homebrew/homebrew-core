class Azcopy < Formula
  desc "Azure Storage data transfer utility"
  homepage "https://github.com/Azure/azure-storage-azcopy"
  url "https://github.com/Azure/azure-storage-azcopy/archive/v10.14.1.tar.gz"
  sha256 "7fdf462e89c7c2ffa6d093a49cd2bf54457864856442dc81607212e4e0f88548"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5a30ed73bc46457cd5ef7869b1e32bd66a65caead10ecedefb1271bd8530fe8d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "81b8ff92efa9acca3b59bfc20b36d0f1b70414a7bae971e7c2d885b43eb28b31"
    sha256 cellar: :any_skip_relocation, monterey:       "ca64963640de4fecdb739f22dee63adfe4d70d73f9cbc26de4028a7f7fe03031"
    sha256 cellar: :any_skip_relocation, big_sur:        "cfad91024a726f0de4c3fde52076523bd605aecbbd4fa1e7f2bafab9616b96ca"
    sha256 cellar: :any_skip_relocation, catalina:       "8fb9b33febb213977acd5d0533d89f951b2b07c113ff79836711edee5bdc408f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6e74485941ea1280930a3506aa256a3bf311225f09ff70a1bc1e2a4691830f3e"
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
