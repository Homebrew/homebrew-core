class Azcopy < Formula
  desc "Azure Storage data transfer utility"
  homepage "https://github.com/Azure/azure-storage-azcopy"
  url "https://github.com/Azure/azure-storage-azcopy/archive/refs/tags/v10.21.0.tar.gz"
  sha256 "a7a81921ac48aa6663912e498ee578cc62a09161f7523ce8019fe341d6ea7922"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a29221c76956c520174201939acdc012d154a843ffa56765bb01131a0a2048c0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "93d0574b468933d518f6f22ed33ca499d0e973f6a5c768bbb812e19d9dd6facb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d8e983dcbffb5f924c82df48a2192b7e7809c2ee63dc9375a439d5dd05e90cec"
    sha256 cellar: :any_skip_relocation, sonoma:         "1a0c38d3480b832b64e87d6853d0e2bb3608a11f89ffcb76508d71bf8e45ed2a"
    sha256 cellar: :any_skip_relocation, ventura:        "169e9a38fa3e198b3528623e311f0288a58856743406835707b810694c72cea0"
    sha256 cellar: :any_skip_relocation, monterey:       "4b074a7e3e647552747483cd9fbd01c9d424265369aa602dc1b0ab9e766b7805"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c60700efc127c66561262415535909dc51c106e55d825ac0778e2c53aebd6fd3"
  end

  depends_on "go" => :build

  # Build patch, upstream ref, https://github.com/Azure/azure-storage-azcopy/pull/2393
  patch do
    url "https://github.com/Azure/azure-storage-azcopy/commit/99f2bd8af8d55cbc2cba7320636af880f2e84955.patch?full_index=1"
    sha256 "6142ddf542b8f9ae1b92095c93402e00883b266099b1f17e1f0779ce2628c580"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin/"azcopy", "completion")
  end

  test do
    assert_match "failed to obtain credential info",
                 shell_output("#{bin}/azcopy list https://storageaccountname.blob.core.windows.net/containername/", 1)
  end
end
