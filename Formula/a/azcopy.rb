class Azcopy < Formula
  desc "Azure Storage data transfer utility"
  homepage "https://github.com/Azure/azure-storage-azcopy"
  url "https://github.com/Azure/azure-storage-azcopy/archive/refs/tags/v10.32.5.tar.gz"
  sha256 "2dd92e5f1042c7d26a20e00f0b104da5ea190a9e32aef1eef639c45b8a98f71f"
  license "MIT"
  head "https://github.com/Azure/azure-storage-azcopy.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d104cf4dfdd274ab97038f3d0b2065fe104ebe9e6d22447c94aac8c6e6999c8b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9c65e2ca1565d946afd539dc0bf701a2b8ab67972ec783452482b97aa3220fa8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "920e1797d7a94739716971f24a4e2a393bec6810109fdafbfa6c7b33c2b7e7b2"
    sha256 cellar: :any_skip_relocation, sonoma:        "5011387c117248760a5a00cf50b02e265ecc463bfd1aa30c21332c36bd42a475"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6c3705d72b02f9af9cf5790a07e01961a1b5295a26284f9fdbbd568ebe06f63f"
    sha256 cellar: :any,                 x86_64_linux:  "3ba5aecee547bf85b03ad33f8dbd8db414366cf1c58433363f2f3c8c6892d2e0"
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
