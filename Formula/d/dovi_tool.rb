class DoviTool < Formula
  desc "CLI tool for Dolby Vision metadata on video streams"
  homepage "https://github.com/quietvoid/dovi_tool/"
  url "https://github.com/quietvoid/dovi_tool/archive/refs/tags/2.1.3.tar.gz"
  sha256 "299d225fccb6360c5aaa2b8b35416d30f416d6f1746d9ec5820a16f6bbe5fa02"
  license "MIT"
  head "https://github.com/quietvoid/dovi_tool.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "120beef3c83a0d8828289c5bbf7645c9950224e88089a8b6aed625b219ce6c1c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8632fc24a977fc8d228abc6b872ae80baa030d07eed4696e7b42f8fed802ad78"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a80d5309a8239a519a3baee66ec521e4e3f9ce62d2954c1e76eb20e06d06f8ea"
    sha256 cellar: :any_skip_relocation, sonoma:        "2e9cc14d2757a0adf25e84b2bbddc662d08232b6599678979dbceee2ff98715e"
    sha256 cellar: :any_skip_relocation, ventura:       "a0c6e809d88c62e090f557ed407f4cc9c138e498933d7b3ad55f854fdb984b9e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "47a6672f164310531f016c712a65629f0c0d4a96407536c6d509808b87895788"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "pkgconf" => :build
    depends_on "fontconfig"
    depends_on "freetype"
  end

  def install
    system "cargo", "install", *std_cargo_args
    pkgshare.install "assets"
  end

  test do
    output = shell_output("#{bin}/dovi_tool info #{pkgshare}/assets/hevc_tests/regular_rpu.bin --frame 0")
    assert_match <<~EOS, output
      Parsing RPU file...
      {
        "dovi_profile": 8,
        "header": {
          "rpu_nal_prefix": 25,
    EOS

    assert_match "dovi_tool #{version}", shell_output("#{bin}/dovi_tool --version")
  end
end
