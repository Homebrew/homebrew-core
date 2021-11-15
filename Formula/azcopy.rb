class Azcopy < Formula
  desc "Azure Storage data transfer utility"
  homepage "https://github.com/Azure/azure-storage-azcopy"
  url "https://github.com/Azure/azure-storage-azcopy/archive/v10.13.0.tar.gz"
  sha256 "ff3b199a044bb16abc70b1d221f4b92e693b90e204c6ca7ff27d1c857b02d444"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cc4cbc8cfc68ca1906c4a94999e6121ca5573c6bf20d85a234153ba1c6b7794d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a6ef402590c4a392cecee26f41e84dff712308fd9ff12a1ddc3907e1a3849aa3"
    sha256 cellar: :any_skip_relocation, monterey:       "87652c191c0173f07fe09e9a6ac1d56b8fa3f46b6e866b92f2efb23a69994a03"
    sha256 cellar: :any_skip_relocation, big_sur:        "fd18912ddee9a577a33f12d175678e9245f4c09b77a7ba148ddb6241c0b8add9"
    sha256 cellar: :any_skip_relocation, catalina:       "4f7bc9444f9b1dfa52b58d5d4400eaf702a56e420a52f18d423cc8a445ee8e5a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c713bcc655c81265b62b27e6a97d8d3b526a62e5ba22494345e77b406cb67759"
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
