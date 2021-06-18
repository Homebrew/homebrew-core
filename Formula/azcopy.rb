class Azcopy < Formula
  desc "Azure Storage data transfer utility"
  homepage "https://github.com/Azure/azure-storage-azcopy"
  url "https://github.com/Azure/azure-storage-azcopy/archive/v10.11.0.tar.gz"
  sha256 "a766a1c4c5c2b9ce4db2abd3a978ff757fa02b34fdac4c8e3c77c2fce64a0f09"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "474b27d1ccdd417f7fe1d75fe69311e76ec16f8fef56ccba1ed35f323318fd70"
    sha256 cellar: :any_skip_relocation, big_sur:       "a2e2649c4fdbc5453e6b33536af505a9747d59413d6314fc1171d68d96c0156c"
    sha256 cellar: :any_skip_relocation, catalina:      "4eca8b06dde2477846598d23d0dbc08a7c18de91b6185656f0dd0b9f7c0b5302"
    sha256 cellar: :any_skip_relocation, mojave:        "908b48e69521aa5b29eb1e300d21e9b9212b1930dd860a7caf7b4b2ef4191138"
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
