class Azcopy < Formula
  desc "Azure Storage data transfer utility"
  homepage "https://github.com/Azure/azure-storage-azcopy"
  url "https://github.com/Azure/azure-storage-azcopy/archive/refs/tags/v10.19.0.tar.gz"
  sha256 "33ce1539b56a4e9a38140374630bd9640157bb44d0c57b3224a5e5f592ab5399"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cb04a296fbe6210f71e99f151666f319acc806bab587b0c7bc3291925b3ac532"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f669a086104ac89dbbfe7c4f4da07e65ae707dcaa848e7db65b1eb95ce5146ae"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "94bf052e621962f49ad2f7b95c628c6fd582f3a0a0606ce88029da0e5cbe8020"
    sha256 cellar: :any_skip_relocation, ventura:        "956eda0b5c863a44d920e538df51ea51083a5e9d9fc280517b268fd821469a73"
    sha256 cellar: :any_skip_relocation, monterey:       "74a9a62207a635a6ff4faa3f58f9c1bb52ed961d0501129a0a06367fabad805f"
    sha256 cellar: :any_skip_relocation, big_sur:        "2eb8f14e150c23f9eee7658f0bfa09a86706ef23bdf9c251e09e65e2a651d11b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bb19b5428fed3d56e9f7943c8bf0ab7b6ad013da6a1e64d91f51035a85b6a7d2"
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
