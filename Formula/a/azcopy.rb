class Azcopy < Formula
  desc "Azure Storage data transfer utility"
  homepage "https://github.com/Azure/azure-storage-azcopy"
  url "https://github.com/Azure/azure-storage-azcopy/archive/refs/tags/v10.34.0.tar.gz"
  sha256 "65ba78cd16bb65ec6adaaa5cb6df7bcb7d4ddd376cdd297d453308080ee88d41"
  license "MIT"
  head "https://github.com/Azure/azure-storage-azcopy.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "59ba12aa5eec442163ddcacbda69b0d97e1411346e7bc420c1e997b668c6c428"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "6c804f02558a40594010cdeb722a5e29e2e04cdc1fd7cd9cd68ba0151856873d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "4660038b4ea08ea80958d5d8852993d06e6470bff754b9e5956bdfc36a801e3a"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "da21d4d9c4b0fe6f30086fb95616dc1f34b3b1189da2c7f9647d66bf60e7439c"
    sha256 cellar: :any,                 x86_64_linux:      "cdd74c8b38720d9abd98484f505dce586c95d70ede181a1f58536386ac5b40c5"
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
