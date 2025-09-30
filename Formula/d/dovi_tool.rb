class DoviTool < Formula
  desc "CLI tool for Dolby Vision metadata on video streams"
  homepage "https://github.com/quietvoid/dovi_tool/"
  url "https://github.com/quietvoid/dovi_tool/archive/refs/tags/2.3.1.tar.gz"
  sha256 "090888c35da017e290614b70108653ea975034c23b48ddd459538a1a6e4cc05a"
  license "MIT"
  head "https://github.com/quietvoid/dovi_tool.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d501377cf2e0ad9c041a5d6f0aeee3ba51a9886c196483017e8e60f47c5703cc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0dd620b246ba3cc023aa718042299700f412bbd8449abdea27f7724a47760610"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9ad94c3fa4979b73f7ac30b956f62591f86622841bec055a62b2f4e05ca207ac"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "498c071bd8902b3c5bb404c1d5115912b88423bd8a1751ebaab7ade3a46a395a"
    sha256 cellar: :any_skip_relocation, sonoma:        "0c051cf1e27759e3ee49b1dd0e50fa726953447c61c2060b60bfb93c88615cff"
    sha256 cellar: :any_skip_relocation, ventura:       "db1ff82fb34caea4be244020fc3edadca05396465957fd6905778fe86658e16f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "13b7825ac9b6d1058cb4b743d25a77473126ca1d907b1a473908c29ff25166ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "435abf7e0424828fe2aba09c1625ef91e92fd36b1104656233f4334507d4c408"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
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
