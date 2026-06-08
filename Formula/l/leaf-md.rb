class LeafMd < Formula
  desc "Terminal Markdown previewer with a GUI-like experience"
  homepage "https://leaf.rivolink.mg/"
  url "https://github.com/RivoLink/leaf/archive/refs/tags/1.24.1.tar.gz"
  sha256 "84cc0d67420b015799a18fed0c84d8d67092740cbc39280377efb192c73b0c89"
  license "MIT"
  head "https://github.com/RivoLink/leaf.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2793f9991b52b5608efd0d866ebcc4ca2320013c3ae1c8d5446f58d9b74843ae"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5f8f866f7cd86ec43b9cde7a99840ae801303f15b176a6bd69c3f21a062da58f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d23362ef5315d015437ea76fe2081f2c55384298a203eac2355e69235be2c28d"
    sha256 cellar: :any_skip_relocation, sonoma:        "932435256f3b7f2ddfb3fb032cd08a0d5f84af0d6e092417d018b3035763f2f7"
    sha256 cellar: :any,                 arm64_linux:   "1b772f4f108ebd595f14697544235a52cc6302e95ae3a247b445df587dd496d2"
    sha256 cellar: :any,                 x86_64_linux:  "794e7bcb20619df92e95b65bc6b63b821e6394120b773831c2913591fdaa41d2"
  end

  depends_on "rust" => :build

  conflicts_with "leaf", because: "both install `leaf` binaries"
  conflicts_with "leaf-proxy", because: "both install `leaf` binaries"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"test.md").write "# Hello\n\nThis is a **test**."
    output = shell_output("#{bin}/leaf --inline test.md")
    assert_match "Hello", output
  end
end
