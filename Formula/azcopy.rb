class Azcopy < Formula
  desc "Azure Storage data transfer utility"
  homepage "https://github.com/Azure/azure-storage-azcopy"
  url "https://github.com/Azure/azure-storage-azcopy/archive/v10.16.2.tar.gz"
  sha256 "728ab94c62abfd33404f632ce587f09e8b031632d33130997055617ca0b99334"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "67693d881149aa25c7a651bb52c0d4bc8f4f93291eea5ac58f01ebba359ed9f3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "22abeee9fe7abc8f15007cb1fc4e1bb6b11d98f9964eccbb6e50fa44cdd1beaa"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8e0322da2d1ad2330c492f5fd52e951c3a30bef7fd0288f1e3aa24c1d7f5570b"
    sha256 cellar: :any_skip_relocation, ventura:        "a19235e140b194d039ab9dfe3031a2010709305a555505fc02daa45941aa1b4f"
    sha256 cellar: :any_skip_relocation, monterey:       "7082fb802effbdc62dc83510f17d35ad6d24fbca539785cfe0592cd5b54814ca"
    sha256 cellar: :any_skip_relocation, big_sur:        "af810593611c278a97b77805f9bbf6bc07e79a2f9c285337e41222913773c3b6"
    sha256 cellar: :any_skip_relocation, catalina:       "5d63f26e694e852ae8c68cb2d0fefe4b6b03fa74980f3a26d51aad2fb1b6109f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e926f85f0acd9849196cb6a9a453d63f0435e65a4125d215a1bde5884d33ea5f"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args

    generate_completions_from_executable(bin/"azcopy", "completion")
  end

  test do
    assert_match "failed to obtain credential info",
                 shell_output("#{bin}/azcopy list https://storageaccountname.blob.core.windows.net/containername/", 1)
  end
end
