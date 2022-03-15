class Azcopy < Formula
  desc "Azure Storage data transfer utility"
  homepage "https://github.com/Azure/azure-storage-azcopy"
  url "https://github.com/Azure/azure-storage-azcopy/archive/v10.14.1.tar.gz"
  sha256 "7fdf462e89c7c2ffa6d093a49cd2bf54457864856442dc81607212e4e0f88548"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c088ae07f46e676d90f6c9dcd104b2c77d5e8174a8cd06e890d8c0f0059e50d0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a051632c48668b7665e0626da21fd1db04d13bce85568032cbdbd7c09c0a405d"
    sha256 cellar: :any_skip_relocation, monterey:       "6a9004e902d55f71dfe5d533b245d2327898213941448e0a02ef12d3773a7233"
    sha256 cellar: :any_skip_relocation, big_sur:        "829202256ed5cfb0c7b08c130dec058912d0d78e5fbd8163a053369747690d59"
    sha256 cellar: :any_skip_relocation, catalina:       "e7a53b2e80471386c06b5b6b0c257cbeeb1eb2e1f4ffdcd9c9232323d7e4ccc3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "67c0752afecd0bfeecf7485616612888e5c7d9690993fa9d476bd394c8a83625"
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
