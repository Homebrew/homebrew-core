class Azcopy < Formula
  desc "Azure Storage data transfer utility"
  homepage "https://github.com/Azure/azure-storage-azcopy"
  url "https://github.com/Azure/azure-storage-azcopy/archive/v10.18.0.tar.gz"
  sha256 "93dcfeb72fc4750e9a7aaefc7f50bf97c85ff5f5173a4b33e5a977fb6d656105"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f3f16ad9f3a6fbb09cadc001962bbc1ee513a6261aacec2ed3ce3164826ae3c2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "05b41760344767124b4bb42ced095d0deec41103c3afa9cf79d499443aafff33"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "004390ff0f4c1fdf5ad8539b641b9801432ef8c8ba25bf2f766a73c586867d6d"
    sha256 cellar: :any_skip_relocation, ventura:        "f8b7d2b4a6e3adf0b199a12365f78e92c6435a8e9790af48dc4bb4d8664c5d2f"
    sha256 cellar: :any_skip_relocation, monterey:       "e527933850102e20d46aab77d6806f39d5a7c7ca85749f8c8d86e5240cb8bb8b"
    sha256 cellar: :any_skip_relocation, big_sur:        "a7122928f4fabb897aaec28d27a941ac487ec4e9f6eb1f6cb147b57218dc6045"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1eabab1a4bf739548a8b034964386945f21527a9a432adf8063e181c6f64160a"
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
