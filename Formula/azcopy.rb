class Azcopy < Formula
  desc "Azure Storage data transfer utility"
  homepage "https://github.com/Azure/azure-storage-azcopy"
  url "https://github.com/Azure/azure-storage-azcopy/archive/v10.12.1.tar.gz"
  sha256 "ac7e9ce94152e2e9c5c524a9b414d425debd8909fea545c53c377bec14eefe70"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "2980b3c14c48aae17dd1820f1d4ae5864cc9830bf66de9a9008b4d4de4f78ac6"
    sha256 cellar: :any_skip_relocation, big_sur:       "3bc608a490bf133bd3cc960a768eb08f3673a8107d562b99629cbd13e446ccea"
    sha256 cellar: :any_skip_relocation, catalina:      "4bb904f6edc4c9065e3f7fa154c907bb81b9da2e4f06f6956ef6e1bfdec4c813"
    sha256 cellar: :any_skip_relocation, mojave:        "840879ad99be0c1faf91054107e23c5a2a7e98abeeafa1bbfb0258c71d12c619"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2ccecc6461f131ca79677468e9597304e4179bf8ca9493247ef798ee54768bd4"
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
