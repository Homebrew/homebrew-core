class Azcopy < Formula
  desc "Azure Storage data transfer utility"
  homepage "https://github.com/Azure/azure-storage-azcopy"
  url "https://github.com/Azure/azure-storage-azcopy/archive/v10.16.0.tar.gz"
  sha256 "cde6fed812e36c7d1ff9ec539139184f650c5d5a048754d2550533d17fa5bae3"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4941b577cf3c8b76a6206e7c6f81ca8a484f956d3bf0ea51a0878633a827fad3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f343ac6eb85db3f90757f6968849eefcba2f82ea0ec525f2151fc12a220adc5f"
    sha256 cellar: :any_skip_relocation, monterey:       "58957f452add561a358469589417998193a0e601f8ce2bd36ee951231c5686e7"
    sha256 cellar: :any_skip_relocation, big_sur:        "70e6dd98a1ea17582c51f828cebc9b344e5d48c303f9c44338d337744fecc8c9"
    sha256 cellar: :any_skip_relocation, catalina:       "dba9196441f148fe5657d77afa07790c4c9efac6aed6e5ddf0cb14ed230fea3f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9cb48e8ce9f88bfa41cbcc576a80d8c82fd98e688db00b52f7f3c37806a2be21"
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
