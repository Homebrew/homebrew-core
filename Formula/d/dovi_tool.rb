class DoviTool < Formula
  desc "CLI tool for Dolby Vision metadata on video streams"
  homepage "https://github.com/quietvoid/dovi_tool/"
  url "https://github.com/quietvoid/dovi_tool/archive/refs/tags/2.2.0.tar.gz"
  sha256 "44a5f860301ab6ef1a02d8943e210c201ff3733d52b5929a5ab72a09e555041d"
  license "MIT"
  head "https://github.com/quietvoid/dovi_tool.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6c34699e13bf1c5fd04879f2c64a0074032c6d3effc79ee56fac744892bd4d36"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5573809c7af735d6adaef77e998bf34f3ad2fab891fac4a11668241e9c8cb48d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2e35381caf2775371ce2a35f7a9aa71d2f69dd272a1777158cf499fa667e8f54"
    sha256 cellar: :any_skip_relocation, sonoma:        "f22ff979e01886de1db7d0fa4f293839c367eb15ddee1aaaccf7de1f00bad9d2"
    sha256 cellar: :any_skip_relocation, ventura:       "e20491c0a0cd8351119f2c933bbd2c965b3a17ec77b6a499d64779ce49734a89"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "102f3161283dca3a3b8811ceda88ddf2a1d17abec112d22acae986574e88f8c3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8254aec7392a826c86b3bbbdcd12c7399ca78f863ff6b9909ee899e948f02072"
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
