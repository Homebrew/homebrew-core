class DoviTool < Formula
  desc "CLI tool for Dolby Vision metadata on video streams"
  homepage "https://github.com/quietvoid/dovi_tool/"
  url "https://github.com/quietvoid/dovi_tool/archive/refs/tags/2.3.0.tar.gz"
  sha256 "2c76f8c7a17ff6af71c168bc9b041e94efe89b4f91ccde2f3f208c821037069c"
  license "MIT"
  head "https://github.com/quietvoid/dovi_tool.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aed4a808d83f2a898adfa5d3a1ed2185abe4fedfe17595b184c0fa6befc499c3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "35f639f5d9af6f6b421f1f372bb02ffe9b6b8c2a8b86a18d514ed437c301276d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ab2be82fdb4d0a0e0f140b448423225ce5f4555e2d3eb441689cdd8f40e13f5b"
    sha256 cellar: :any_skip_relocation, sonoma:        "7f35aa28de4b0cb7f6cd5d38a9678e8a15d2e6a5fef77667b3dabe3d0586b555"
    sha256 cellar: :any_skip_relocation, ventura:       "0afbe5ac149ad323514e8d1b1e06699ef395a3a1eee6e7e10af725c5005d10a4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d0470d048b802ecf3409278334743c1367d14ac5d6df1bbe1bb784473780bda6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "417a3dea8921425f889eb3cba6aa2a08024e24f1d52d5ca2dfa8b7a6dbaa9e2d"
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
