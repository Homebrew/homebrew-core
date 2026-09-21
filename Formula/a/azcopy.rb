class Azcopy < Formula
  desc "Azure Storage data transfer utility"
  homepage "https://github.com/Azure/azure-storage-azcopy"
  url "https://github.com/Azure/azure-storage-azcopy/archive/refs/tags/v10.32.8.tar.gz"
  sha256 "07b362e171e193993b1d0384215e7bef34bc7dadaf681ba4ef5e8a1154bd1556"
  license "MIT"
  head "https://github.com/Azure/azure-storage-azcopy.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "d0cde31886e55885b372fd516fef8d047bede76ce5adb561095526982776878c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "1d88718cd51d49313d2e1867819c253282a68594f7f0708fbf404f59ca5969ad"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "b7b81451f3328783151378fe97159bbee04717c653da8d23b6bd869481b1a9af"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "0d2480525cdc8949a3a0288f85cd78212381de2a32a162d6a653240d5835cf72"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "be9b3b856ee69fdfc3ecd50ad7b139f11539a93637133379c90d3425bbe9f7be"
    sha256 cellar: :any,                 x86_64_linux:      "94383b205e506bf43854130703b797faa85b73cc8fab1e1640fa47f3cd7b5f00"
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
