class DoviTool < Formula
  desc "CLI tool for Dolby Vision metadata on video streams"
  homepage "https://github.com/quietvoid/dovi_tool/"
  url "https://github.com/quietvoid/dovi_tool/archive/refs/tags/2.1.2.tar.gz"
  sha256 "a905a8ddb47583d3d9a7571a736a44c76f3ebf0b5838aa01d401f5715825785a"
  license "MIT"
  head "https://github.com/quietvoid/dovi_tool.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "5f4cc20a661660fe6b7f7604c29950be505c2a3627642b528ae01bb865d9a77e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "065bcde72257b4362ba1cd86cf0da0680154f8ddb2bef6f0cb509fd2e0fedc46"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "db397ea4ddefb2f62cfef824f20a5f37e262a13b448571c5539ef010afd7be89"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "617d076067b186d349e797276c514187da1568865d67a04cf4b2836440a23f91"
    sha256 cellar: :any_skip_relocation, sonoma:         "4fd150b17d01d130ccae340316258ae7fc015c5f2928744c9cc7c8ada9aba8cb"
    sha256 cellar: :any_skip_relocation, ventura:        "90d528f94c49fe96c3d6cce5ea48e2224a90986ce7eb97155ae6b77d613d830c"
    sha256 cellar: :any_skip_relocation, monterey:       "b010afc7569973542305cb4fd7bff6320e39f6643f727994f087165720d1588b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c4454c7bc42639f5044ef71567528bc2dce813a12a7e915d4dfac533e2134f5a"
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
