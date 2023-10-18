class DoviTool < Formula
  desc "CLI tool for Dolby Vision metadata on video streams"
  homepage "https://github.com/quietvoid/dovi_tool/"
  url "https://github.com/quietvoid/dovi_tool/archive/refs/tags/2.1.0.tar.gz"
  sha256 "06b7332649959710ec00e25a9b4e4a88ee7766149726d6e2f60c3b5bb6292664"
  license "MIT"
  head "https://github.com/quietvoid/dovi_tool.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d3710cc3e2b3312063431485fc5c3f2623f0dbea38b669955ce32f7273ebbb87"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7fae1076f6a57da50d9b53b8b3f0df9a952744ddcc2f47176039fe5c3ab4f934"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a4f5be9943c2e4464cf540618f0ed2d34dfc098388d67fb12e095920d1433c32"
    sha256 cellar: :any_skip_relocation, sonoma:         "67b36ed015f9bdbe34406ef2a56fffad68e1be1665b265b2333a5df4098478ee"
    sha256 cellar: :any_skip_relocation, ventura:        "295c1a2354b03787d15a586c8e56f999fc217e5ebabb5f6de92f2c5de5d9f7be"
    sha256 cellar: :any_skip_relocation, monterey:       "448e8d027283d5fa0687ec45cdf1dc51e2b4fb9b8971becb1b05c7e057311dd8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f38cb82f72fb00869c5e93098dfc84491200bd6b33aa38eb7cae9330f9a751e8"
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
