class Azcopy < Formula
  desc "Azure Storage data transfer utility"
  homepage "https://github.com/Azure/azure-storage-azcopy"
  url "https://github.com/Azure/azure-storage-azcopy/archive/refs/tags/v10.22.1.tar.gz"
  sha256 "fc7314f534845353252a743928845bfc0b1a9e56752e9cf01e4e4c12eb0f1bf6"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "680e4416077a14b061423250853ad1ce78db6eed006c6625795c8384282dae71"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "19bc5bf031f9ec110220d2851818479911fdd50f18afdfa10ff03ac32a5c0843"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "42c4bceec2575ca6ee00f226af3404fc9f6efa5a9829926d036a68d4ceeca24c"
    sha256 cellar: :any_skip_relocation, sonoma:         "8ce0a0ef0a598cca824d8e9847239fb965b8d93eb731cdbd1e8317f9902a3d30"
    sha256 cellar: :any_skip_relocation, ventura:        "b72dd9cf961e7e25e6a0833280f44dacb1d5ff70a65c023fcbc76c8718125927"
    sha256 cellar: :any_skip_relocation, monterey:       "9fa2f07946631708455106f6bcb2fc78081b184518aa1648cc9bbc337b495471"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9db084c365831e431bcce8264c39666838c40108f57b68fd8639b8f8e037115f"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin/"azcopy", "completion")
  end

  test do
    assert_match "failed to obtain credential info",
                 shell_output("#{bin}/azcopy list https://storageaccountname.blob.core.windows.net/containername/", 1)
  end
end
