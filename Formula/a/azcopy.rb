class Azcopy < Formula
  desc "Azure Storage data transfer utility"
  homepage "https://github.com/Azure/azure-storage-azcopy"
  url "https://github.com/Azure/azure-storage-azcopy/archive/refs/tags/v10.32.7.tar.gz"
  sha256 "94dafadafaed121ee3a5c0a487b9fd3331e8c4e676a623ad53041d1ae0cba7b2"
  license "MIT"
  head "https://github.com/Azure/azure-storage-azcopy.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "00a107dda7bebdde553c175f5dac7e898dae0fc207187bd8280f6c4813e8540c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7397010ac769d88d963142ac675138a213d170f6cfb30bd658e9937af180b05f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5bfe89821455837c4365536c95c55b18ae5a79cbe4495f24be9b758d45267dd2"
    sha256 cellar: :any_skip_relocation, sonoma:        "fd34da33c6844cdd1165f743651b52dc217abfc2606e905fd43c1e4845f9c178"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5e92b37daacdf94cba3fe60e82974299b7b018bd7e595f6cbd7ef07a5b4ed891"
    sha256 cellar: :any,                 x86_64_linux:  "40f71ed79e785906e2dcc83bfce022c582d0c2fe8aa679ced6a067f74deadae0"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args

    generate_completions_from_executable(bin/"azcopy", shell_parameter_format: :cobra)
  end

  test do
    assert_match "Existing Jobs", shell_output("#{bin}/azcopy jobs list")
    assert_match version.to_s, shell_output("#{bin}/azcopy --version")
  end
end
