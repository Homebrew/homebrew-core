class Hdr10plusTool < Formula
  desc "CLI utility to work with HDR10+ in HEVC files"
  homepage "https://github.com/quietvoid/hdr10plus_tool"
  url "https://github.com/quietvoid/hdr10plus_tool/archive/refs/tags/1.7.1.tar.gz"
  sha256 "39a6b63f83c8433e6e2ea1a4b54a3de6dbf24fff64b69566a99e6328f4f1d2e2"
  license "MIT"
  head "https://github.com/quietvoid/hdr10plus_tool.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "78ae74fd537427b5a147308e8bc2a67cb88530272a0cf5ab5399956a352098b6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5dfeac19a6b661e94df935d27fa225dc73338b93f1b6b8b47b2c4990905ef1b0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "65b805124a49edf9db43f55cbecb47cd7a79b5dfb9b2dd6eb665ca5a82fc9489"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b7c7ff273efa5264c458d146a7a8a063ac0484043332b62dcac2feb63d8c74ce"
    sha256 cellar: :any_skip_relocation, sonoma:        "942613e0a0a9fcc2636d63df7a992f20a61c1060ac127f7d7132daa9012bee17"
    sha256 cellar: :any_skip_relocation, ventura:       "0243742abe39f9b62b887608e8844d2474fbe57645037f36c7143bbccfef3833"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f5f68486d96825cbc9d807f2024c53bee11dd984115747be11516602a7545097"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d6b11863c103ed0f67eba0ea2aa044bfaad6d95a1cb6dee3e03796ca5f1c60dc"
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
    output = shell_output("#{bin}/hdr10plus_tool inject #{pkgshare}/assets/hevc_tests/single-frame.hevc \
     --json #{pkgshare}/assets/hevc_tests/single-frame-metadata.json --output #{testpath}/injected_output.hevc")
    assert_match <<~EOS, output
      Parsing JSON file...
      Processing input video for frame order info...

      Warning: Input file already has HDR10+ SEIs, they will be replaced.
      Rewriting file with interleaved HDR10+ SEI NALs..
    EOS

    assert_path_exists testpath/"injected_output.hevc"
    assert_match "hdr10plus_tool #{version}", shell_output("#{bin}/hdr10plus_tool --version")
  end
end
