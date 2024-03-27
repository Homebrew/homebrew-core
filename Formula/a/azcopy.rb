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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4966c7a7e5592c0acd834b4315785fc1bc1135c1456eb8275dee49adf55cc6f7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f8843af6944b3b7c0e523fe86edcef26f2a0af5a15b1dd4bc43ae8ff10b18166"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "355a638fef03c241e2e502d3c5db7be2e7439721f278507dfa81d7424a5f246b"
    sha256 cellar: :any_skip_relocation, sonoma:         "0cef01752318b3b8a67692f2eb536270cdb56cc44d6cd10c768d83f694dab692"
    sha256 cellar: :any_skip_relocation, ventura:        "efdf1155f1484b842f5f38cb2c71eada8bbdb8a6a145156d1490f11ae24ab34f"
    sha256 cellar: :any_skip_relocation, monterey:       "ac62f030f893c9ce20f07b6cda5dd7b51684d2f875d25f234d069d8d6887c797"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "466a67078a5856f5c5ddc4f71d1ee6ed5c512804a9e1db11dccdc80c4f232b7c"
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
