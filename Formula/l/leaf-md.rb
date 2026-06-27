class LeafMd < Formula
  desc "Terminal Markdown previewer with a GUI-like experience"
  homepage "https://leaf.rivolink.mg/"
  url "https://github.com/RivoLink/leaf/archive/refs/tags/1.25.0.tar.gz"
  sha256 "94b8cb7dcf7b3234a4c3c9e2b6a006129c7f97d8c0b4389966249f0cf2e37825"
  license "MIT"
  head "https://github.com/RivoLink/leaf.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9cfaf6ee97b96a475b70569d2e474d512acc4bd4e8cf32cae37e4d3a642a5236"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2cf96b2bf1ed8a6876327eca45c63e17ba78475230f34919d080b36af92568b9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9e98591dcdd9276c29a6fb7bf51b710977cb1a4d4bb4d2cddac92bcd8d157bab"
    sha256 cellar: :any_skip_relocation, sonoma:        "a464ed99e6950ca7e2efd6aee12d77eced7eaa2aeb985579c9960b9715e3d303"
    sha256 cellar: :any,                 arm64_linux:   "fa8fb10d1243c48176222e63c2559ed90c2d8ce0f34a0963e3f4fd55e8f940e1"
    sha256 cellar: :any,                 x86_64_linux:  "db5c8f9876425df7606724faa9132c2cbf9e309f211faf28a0677fb02455b55c"
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
