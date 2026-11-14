class Azcopy < Formula
  desc "Azure Storage data transfer utility"
  homepage "https://github.com/Azure/azure-storage-azcopy"
  url "https://github.com/Azure/azure-storage-azcopy/archive/refs/tags/v10.34.2.tar.gz"
  sha256 "6ebe5d4d8a4776313d0440230a8a8d94a227d09e072d745d592b359b205e719f"
  license "MIT"
  head "https://github.com/Azure/azure-storage-azcopy.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "782c4683bc1addbca6a8289d3c5901255298691e195041e48adffce9b734fb7a"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "9ff4fb83ea95240a69c71e630bea93cb911aafac5c98c6e5dc8d3ab222a7a4b3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "69f2c9eab08467e57654e726508a6c0c0b1911b2ab23b4af28551500af0f744d"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "85774c164000bffad92cdde6360c50f0679e871de61f5176b36e8ad49fdf8a0a"
    sha256 cellar: :any,                 x86_64_linux:      "479ff686a324841b3fd4e947f36bb64ae8da231fb5a0bd533ccdbc2fd5c26746"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args

    generate_completions_from_executable(bin/"azcopy", shell_parameter_format: :cobra)
  end

  test do
    assert_match "Existing Jobs", shell_output("#{bin}/azcopy jobs list")
    assert_match version.to_s, shell_output("#{bin}/azcopy --version")
  end
end
