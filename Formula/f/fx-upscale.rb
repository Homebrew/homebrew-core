class FxUpscale < Formula
  desc "Metal-powered video upscaling"
  homepage "https://github.com/finnvoor/fx-upscale"
  url "https://github.com/finnvoor/fx-upscale/archive/refs/tags/1.3.2.tar.gz"
  sha256 "4dc10cbbd23acbede656215259ac3644e9472915840243409b34c6bc471ff11d"
  license "CC0-1.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "4311a88b2ecde390d839f18846834af3355730a9eddb69becfeedb2ca4bc31a8"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "716acd22ebfeb3e4fc274d5a6e7a8a46f33b08f1c44a52c1dd6aea8f2e8790a8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "7e70bc33a0cd634e64e7d4cbffb3776d3240a6bd43b892c2c2ea128bd673e94d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "915c54fd5c3260a3b7f213b54de693275572e1589bea652e4032e771ccc872d0"
  end

  depends_on macos: :ventura

  uses_from_macos "swift" => :build # swift 5.9+

  def install
    system "swift", "build", *std_swift_args
    bin.install ".build/release/fx-upscale"
  end

  test do
    cp test_fixtures("test.mp4"), testpath
    # Upscaling needs VideoToolbox services that the test sandbox denies,
    # so only check that the video track is read before the size validation
    output = shell_output("#{bin}/fx-upscale --width 20000 #{testpath}/test.mp4 2>&1", 64)
    assert_match "Maximum supported width/height: 16384", output
  end
end
