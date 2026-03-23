class Azcopy < Formula
  desc "Azure Storage data transfer utility"
  homepage "https://github.com/Azure/azure-storage-azcopy"
  url "https://github.com/Azure/azure-storage-azcopy/archive/refs/tags/v10.32.2.tar.gz"
  sha256 "83ece86f70b36492670e8ac08ecd7a2f9419713a34e1f347c05e58f16ddb2df3"
  license "MIT"
  head "https://github.com/Azure/azure-storage-azcopy.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "296ae293c65b15cb7390aec99f0d1db93b171659812f04123dae6554810c1aee"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "88e8bcde409f30b0a158c816c7d57ca7d7e952f4b3e4f334a880483defe28d4a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "945d9cac55f36cc62fbcaf1ff408a69b72abd92631f17b8738df624f39235b70"
    sha256 cellar: :any_skip_relocation, sonoma:        "30f2c01346bc661efced343bd81e311d70ff91b70c6de93968f7c7a3da0cb979"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bdd46b134c2baa5b8d376a4e44f47353eec0e14d31328c66ce77cd4c84812f4b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3313cc0a75b5effddb92efe1c0ec078f65c18b59a3c853834cd89958b4e9f5a9"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin/"azcopy", shell_parameter_format: :cobra)
  end

  test do
    assert_match "Existing Jobs", shell_output("#{bin}/azcopy jobs list")
    assert_match version.to_s, shell_output("#{bin}/azcopy --version")
  end
end
