class Azcopy < Formula
  desc "Azure Storage data transfer utility"
  homepage "https://github.com/Azure/azure-storage-azcopy"
  url "https://github.com/Azure/azure-storage-azcopy/archive/refs/tags/10.18.1.tar.gz"
  sha256 "80292625d7f1a6fc41688c5948b3a20cfdae872464d37d831e20999430819c3f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5ca9b060761c0859b5e568b7b4f9611d647e2038f27ac6c86c20abe60272c122"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "15b50da85bc482f4a8c392d43cb55e98e39e5b85cd00098d1622c61275e6ae47"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0d99501e23eb857e7ad3e9b3bce5cfa9238817e03ffda77a966b235043980154"
    sha256 cellar: :any_skip_relocation, ventura:        "2c40a702bd4053e10f6f13ddc436ed2667a409b2e640346ad1c697ba4f4211a2"
    sha256 cellar: :any_skip_relocation, monterey:       "e74c14f6b0ee11e3b830a0d112d76be4b226cdc2c96c18540025864e9901ac3a"
    sha256 cellar: :any_skip_relocation, big_sur:        "0b53638a606847c91044946cb3be581d6624d7669fcb42c02dd2d281641e3ee7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c0332332bf7489f906868728904bd6a09650f763b968c9189854073caa5e8c15"
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
