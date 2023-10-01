class DoviTool < Formula
  desc "CLI tool for Dolby Vision metadata on video streams"
  homepage "https://github.com/quietvoid/dovi_tool/"
  url "https://github.com/quietvoid/dovi_tool/archive/refs/tags/2.0.3.tar.gz"
  sha256 "6a4afe2733ab1a4eca6ff98c6038f60bbbed5c649b99c239759ccf0b17a3f818"
  license "MIT"
  head "https://github.com/quietvoid/dovi_tool.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "be9203db492cbbc19a2be63bc6e3c38afbf400cc7a248bddc1bbc154082230f7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2969966d41ac5f184920327758aef057d6c494efc5bf30c689825d2bd2f288b7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "18b6fa8b33d62fceee6e7d3f93476ccf8aa434d47a92908b6a7abe6d3994ca07"
    sha256 cellar: :any_skip_relocation, ventura:        "20d201b2018edece99efd7d2697dde13fa178d45427ec67e403293a403aa265b"
    sha256 cellar: :any_skip_relocation, monterey:       "571131171d3f95269479c29bfbfd0caf2ea4ad8fdbeee37ae17fea39ae845e15"
    sha256 cellar: :any_skip_relocation, big_sur:        "5c1b7416c7abb7b987e03f50929c8cabbc8c8b8907e4fa3d834c4173b630f52e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "68f211eeb42e98aba295b3fbdfaa708e2542c7dbf17e382e51b5fb4ef620efff"
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
