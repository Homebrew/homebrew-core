class Azcopy < Formula
  desc "Azure Storage data transfer utility"
  homepage "https://github.com/Azure/azure-storage-azcopy"
  url "https://github.com/Azure/azure-storage-azcopy/archive/v10.8.0.tar.gz"
  sha256 "95866844ff1bb315879b2f1ef70f7076a4cae2391d289af474d75ee2ca3b023c"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "8e0a80ce0dba2d742dedd7b6ad79abaa240b4ff9d67795a4cf7a3fe8e0b53b4a" => :big_sur
    sha256 "e7a8629f1bb894ea1e781abb5af973344d7b667fe0b077c6a7563ab6714665df" => :arm64_big_sur
    sha256 "b9a7efa7205e5e6fd246884eb6858ed020c76abbece1d8c8c6cc61cf941564a5" => :catalina
    sha256 "0cc3410bb462732ca1ecad141c88d97c87c43d7672ead705e6d52bc286c94422" => :mojave
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
