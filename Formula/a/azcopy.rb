class Azcopy < Formula
  desc "Azure Storage data transfer utility"
  homepage "https://github.com/Azure/azure-storage-azcopy"
  url "https://github.com/Azure/azure-storage-azcopy/archive/refs/tags/v10.20.1.tar.gz"
  sha256 "c9d5ba8e81eff6820d8d6b6797461fdbb772616f5eae913e6c6c4a7b2fd78ec0"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c955f1c22b941922c45b55f0430421ba3316c83176bfb3baabb0a0fef3644593"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "82884152f61caf4c3c6b247003de737170866ac9de56e93396da00dcb7b3a421"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ccd881ecede3d0ef85a54ea67d447ef95dc42900699451ddb26cd9345c04d250"
    sha256 cellar: :any_skip_relocation, ventura:        "67908a65d180aac955a07de0f959c28594efaf20d17095f004d55354e8b17d4b"
    sha256 cellar: :any_skip_relocation, monterey:       "15e39bc2d989bbeca382a9d6d96d3b9f3906a4cd5092aac4b7012a468949256f"
    sha256 cellar: :any_skip_relocation, big_sur:        "10a2edbadb8b7701ee63576007d55002678e92f3949061cd6fca7a2100362220"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5fab1e9949a0c9b08786cf21a2080f7a6bf341b1ba3e3ffe777f9d5ea3a87b2d"
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
