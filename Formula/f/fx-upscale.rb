class FxUpscale < Formula
  desc "Metal-powered video upscaling"
  homepage "https://github.com/finnvoor/fx-upscale"
  url "https://github.com/finnvoor/fx-upscale/archive/refs/tags/1.2.5.tar.gz"
  sha256 "4ec46dd6433d158f74e6d34538ead6b010455c9c6d972b812b22423842206d8b"
  license "CC0-1.0"

  depends_on :macos
  depends_on macos: :sonoma
  uses_from_macos "swift" => :build, since: :sonoma

  def install
    system "swift", "build", "--disable-sandbox", "--configuration", "release"
    bin.install ".build/release/fx-upscale"
  end

  test do
    resource "sample-vid" do
      url "https://download.samplelib.com/mp4/sample-5s.mp4"
      sha256 "05bd857af7f70bf51b6aac1144046973bf3325c9101a554bc27dc9607dbbd8f5"
    end
    resource("sample-vid").stage do
      system bin/"fx-upscale", "--height", "1", "--codec", "prores", "sample-5s.mp4"
      assert_path_exists "sample-5s Upscaled.mov"
    end
  end
end
