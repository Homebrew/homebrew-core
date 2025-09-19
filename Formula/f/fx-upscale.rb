class FxUpscale < Formula
  desc "Metal-powered video upscaling"
  homepage "https://github.com/finnvoor/fx-upscale"
  url "https://github.com/finnvoor/fx-upscale/archive/refs/tags/1.2.5.tar.gz"
  sha256 "4ec46dd6433d158f74e6d34538ead6b010455c9c6d972b812b22423842206d8b"
  license "CC0-1.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c73a1a3250d5d984521abe78e97eaabd32eefae16ab490e6a8deedcf579e425b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8538f7bfd182a095ec0eadffaabbd6e293dc7cf585bd155a5fa4b2d748635636"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "46c040ef682faa11c4dd8cce69473ebf07839bce23bbf6dfa0e5e5919dee72f1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5e53602ebf1d934e614a683ae7b564860ce1067ef7994d658cc8b5e9471a128a"
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
