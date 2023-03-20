class Azcopy < Formula
  desc "Azure Storage data transfer utility"
  homepage "https://github.com/Azure/azure-storage-azcopy"
  url "https://github.com/Azure/azure-storage-azcopy/archive/v10.17.0.tar.gz"
  sha256 "f970ad5a68fb0a84935bedc687a6ed8a9d051791e61b032a433ff1cf0ac38105"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9612f77d45eca530efa1e4737e3b4ae0aea2b83076c4933d2b477765cb23e41c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5694ce29bac6124f38d57108813160d6ad547d728beaf6313d40627d9b29f755"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "92d8f01d04f6c1ee393d6cd5b0f63d4766579ae52d793c9afaa002fb9c2637b1"
    sha256 cellar: :any_skip_relocation, ventura:        "880c1ba638e6e5a7b630826da8296801e2850b85c0a7136848cf60463faf1012"
    sha256 cellar: :any_skip_relocation, monterey:       "f256db8acd742f9113eb8aa3364e895950123e6f21f293eeb530e3809a90142f"
    sha256 cellar: :any_skip_relocation, big_sur:        "c27ad3b5699d62954882d3b64378f40cda0a47f1871e801a98e94d404d9260e5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9cf387d915c366effddc5343396292c5e4b4983c6e83746a957f97428ac9ad77"
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
