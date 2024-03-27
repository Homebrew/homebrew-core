class Azcopy < Formula
  desc "Azure Storage data transfer utility"
  homepage "https://github.com/Azure/azure-storage-azcopy"
  url "https://github.com/Azure/azure-storage-azcopy/archive/refs/tags/v10.24.0.tar.gz"
  sha256 "bbb09bee00207eb6e6e80a3ecf58ac39beb956c94f500b62888ed3404580430d"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e59183bf0c393e1c76b11ace2ea3ab592e4bceb7ff70b494a3279bb1883b91db"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "57b6d0482c65b93d4056d6692c067ce54b1ad947b6331965dbbb7914148528cb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "262a4081664ad5c0d7ec529e4e123b53cc5ea77d865d4140f91aa93fb4a69db2"
    sha256 cellar: :any_skip_relocation, sonoma:         "a8ff6b5b9bd15f0a09085e110b71c3c962d4f27acd3a0e21d066a8ba67aafdde"
    sha256 cellar: :any_skip_relocation, ventura:        "78e68a8030239e0647c972d236f48213bd09393484daa14d41dbd072200deb6e"
    sha256 cellar: :any_skip_relocation, monterey:       "5487c0db7d805a3306101836a6cb6e92789d2631aa6f8eb90fca96327547f8f4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c3523ccb0191297984d583d81f0ba8d0b86eaf91fbd478acd0de53f511401604"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin/"azcopy", "completion")
  end

  test do
    assert_match "ERROR CODE: AuthorizationFailure",
                 shell_output("#{bin}/azcopy list https://storageaccountname.blob.core.windows.net/containername/", 1)
  end
end
