class Azcopy < Formula
  desc "Azure Storage data transfer utility"
  homepage "https://github.com/Azure/azure-storage-azcopy"
  url "https://github.com/Azure/azure-storage-azcopy/archive/refs/tags/v10.25.1.tar.gz"
  sha256 "d62f0a88e8899a611d9ef627252e4379bee8530177caca081f155e28917e70d3"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c3d4808edbdc18fadb2738f37e334f52f527cdec357211985bf3bda2bdb85dcd"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4e292d48954b4c96d33d2ca79eb3e6b9df94446134e20e6a22890b7eb660b91f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8c2bfb62c6f852046f285d8d533b3d96c5a4e664f3223859a496a21dbb235a95"
    sha256 cellar: :any_skip_relocation, sonoma:         "98f576f92bcd46834e377101ac3416500f898dd64604419c0df645dd8f432c69"
    sha256 cellar: :any_skip_relocation, ventura:        "e1accaf40e2a3589139c490f1ce662b663982464cf1c63f95f60bd1deeac8d3b"
    sha256 cellar: :any_skip_relocation, monterey:       "30b8ebc3a4a4111a32944e63d8a197436a940721f8e83f9ed1ccd5ef8c4ae5aa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0016c560456e427573eba978a7e4d58fdb2f295eda719c4a912893f538f328fd"
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
