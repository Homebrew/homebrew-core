class FxUpscale < Formula
  desc "Metal-powered video upscaling"
  homepage "https://github.com/finnvoor/fx-upscale"
  url "https://github.com/finnvoor/fx-upscale/archive/refs/tags/1.2.5.tar.gz"
  sha256 "4ec46dd6433d158f74e6d34538ead6b010455c9c6d972b812b22423842206d8b"
  license "CC0-1.0"

  depends_on xcode: ["15.0", :build]
  depends_on :macos

  def install
    system "swift", "build", "--disable-sandbox", "--configuration", "release"
    bin.install ".build/release/fx-upscale"
  end

  test do
    cp test_fixtures("test.mp4"), testpath
    system bin/"fx-upscale", "#{testpath}/test.mp4"
    assert_path_exists "#{testpath}/test Upscaled.mp4"
  end
end
