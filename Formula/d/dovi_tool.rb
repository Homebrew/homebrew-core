class DoviTool < Formula
  desc "CLI tool for Dolby Vision metadata on video streams"
  homepage "https://github.com/quietvoid/dovi_tool/"
  url "https://github.com/quietvoid/dovi_tool/archive/refs/tags/2.1.1.tar.gz"
  sha256 "a383822941732548aef387457fd8611db0172300648490543e22f86da1cee49c"
  license "MIT"
  head "https://github.com/quietvoid/dovi_tool.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "eddf617ac4518116f9b1ae77106e871e09cc71c1abbf42a65b5f57d5f4a2c82f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "533555b60b5fb80fda4a52c1c15d50a7208f7920ff7dd241e37949ca3552310a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e24b538b1e8b9f1a72aac95ac7c2e14da1ff90c43c09731e37fd55cfafc14ca5"
    sha256 cellar: :any_skip_relocation, sonoma:         "e275b77d30d1227a0ac3a7e64e7b8ea381d49107a3e4e8ef73b860057c05cdd3"
    sha256 cellar: :any_skip_relocation, ventura:        "5b0d98db675177543f72d7cf939aff3c237ff09c38226fa53e82ba585792b3d0"
    sha256 cellar: :any_skip_relocation, monterey:       "d9746129ff6a4bf7f2849f4264d0098da7e58d1062f83e448030296b27bfdc80"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3018dbda34d2f4b990b29a899caca91215793017c77b7fa9260c5fc5e5701b99"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "fontconfig"
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
