class Hdr10plusTool < Formula
  desc "CLI utility to work with HDR10+ in HEVC files"
  homepage "https://github.com/quietvoid/hdr10plus_tool"
  url "https://github.com/quietvoid/hdr10plus_tool/archive/refs/tags/1.7.2.tar.gz"
  sha256 "cc917e769bad85323c7f596179798cc96ac878a01ddfd53b210fecae4c891849"
  license "MIT"
  head "https://github.com/quietvoid/hdr10plus_tool.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "19047e28a0a09f67a3468de226119e6ef0f9bc75fcffee81369b8a6605ecaf36"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f0d80db9a201aa675b80359047ff378ddae88e0c43e545eafd641012a891ddb9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7bc000ab8a85fcf936e2c0ca21e7f8f971a89898523b3346d07b173917b605dd"
    sha256 cellar: :any_skip_relocation, sonoma:        "b523b4a7ee63a7fc2a837967be1e92743cac0b5c0eee032c3d63452ff0c3424b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f938183f8ea89d2fce37120e7b4f8aa1ed9c08b72d154c899a9472f95bfc08e4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e2f8bd3ce3cb730e2e071121e9b538c8ba942e329ca3a264f1e14833884f4b7b"
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
