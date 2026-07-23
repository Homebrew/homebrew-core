class FxUpscale < Formula
  desc "Metal-powered video upscaling"
  homepage "https://github.com/finnvoor/fx-upscale"
  url "https://github.com/finnvoor/fx-upscale/archive/refs/tags/1.3.2.tar.gz"
  sha256 "4dc10cbbd23acbede656215259ac3644e9472915840243409b34c6bc471ff11d"
  license "CC0-1.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "716acd22ebfeb3e4fc274d5a6e7a8a46f33b08f1c44a52c1dd6aea8f2e8790a8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7e70bc33a0cd634e64e7d4cbffb3776d3240a6bd43b892c2c2ea128bd673e94d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "915c54fd5c3260a3b7f213b54de693275572e1589bea652e4032e771ccc872d0"
  end

  depends_on xcode: ["15.0", :build]
  depends_on :macos

  def install
    system "swift", "build", "--disable-sandbox", "--configuration", "release"
    bin.install ".build/release/fx-upscale"
  end

  test do
    cp test_fixtures("test.mp4"), testpath
    system bin/"fx-upscale", "-c", "h264", testpath/"test.mp4"
    assert_path_exists "#{testpath}/test Upscaled.mp4"
  end
end
