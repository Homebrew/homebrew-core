class Azcopy < Formula
  desc "Azure Storage data transfer utility"
  homepage "https://github.com/Azure/azure-storage-azcopy"
  url "https://github.com/Azure/azure-storage-azcopy/archive/v10.13.0.tar.gz"
  sha256 "ff3b199a044bb16abc70b1d221f4b92e693b90e204c6ca7ff27d1c857b02d444"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6b69f208199e9c0961a0fd0bf131666d5205e1893a8b0c725267195f6ce5a992"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1b5695aa8fb6ce52898782c407ee6395fb65532a65c5030d0ab438f6ae40580f"
    sha256 cellar: :any_skip_relocation, monterey:       "87c0c978170fbecf7b435caa5290e26582f9eed14eb69d08e23794670350c0dd"
    sha256 cellar: :any_skip_relocation, big_sur:        "895a0df8375076afdd39649821374370c0771a3322cbcbd7f0e052c2157825be"
    sha256 cellar: :any_skip_relocation, catalina:       "e90ca6c0354d38ab4efff87d95a9859b14d065f4cdc1c76d5a8df80300f1c5b8"
    sha256 cellar: :any_skip_relocation, mojave:         "cd976cce204fedeca62755455406045d4d3d6303ca625407105c4b61d2fd4262"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "467fbdd5993292c56a2bc3776b2954093f9db2516d0176b98b80756ed3634766"
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
