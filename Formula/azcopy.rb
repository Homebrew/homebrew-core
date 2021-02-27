class Azcopy < Formula
  desc "Azure Storage data transfer utility"
  homepage "https://github.com/Azure/azure-storage-azcopy"
  url "https://github.com/Azure/azure-storage-azcopy/archive/v10.9.0.tar.gz"
  sha256 "902a88fdab6d7b9c59c2c74f8790bd5c68800b4722100aff6783179e1f8187da"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "e7a8629f1bb894ea1e781abb5af973344d7b667fe0b077c6a7563ab6714665df"
    sha256 cellar: :any_skip_relocation, big_sur:       "8e0a80ce0dba2d742dedd7b6ad79abaa240b4ff9d67795a4cf7a3fe8e0b53b4a"
    sha256 cellar: :any_skip_relocation, catalina:      "b9a7efa7205e5e6fd246884eb6858ed020c76abbece1d8c8c6cc61cf941564a5"
    sha256 cellar: :any_skip_relocation, mojave:        "0cc3410bb462732ca1ecad141c88d97c87c43d7672ead705e6d52bc286c94422"
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
