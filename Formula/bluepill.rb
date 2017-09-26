class Bluepill < Formula
  desc "iOS testing tool that runs UI tests using multiple simulators"
  homepage "https://github.com/linkedin/bluepill"
  url "https://github.com/linkedin/bluepill/archive/v2.0.0.tar.gz"
  sha256 "ac14147d60d568a2403a30066adb99547154c2814007f19390218b78c1e27ff8"
  head "https://github.com/linkedin/bluepill.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "e6e37900e460cd9f592bd264ce2134c55408c66c011b4973650f54ab752c3405" => :sierra
    sha256 "3978c64e6553e9185fb2a0d27629736fcfbfd4c34efa3092a5a0e8e9e2affa66" => :el_capitan
  end

  depends_on :xcode => ["9.0", :build]

  def install
    xcodebuild "-workspace", "Bluepill.xcworkspace",
               "-scheme", "bluepill",
               "-configuration", "Release",
               "SYMROOT=../"
    bin.install "Release/bluepill", "Release/bp"
  end

  test do
    assert_match "Usage:", shell_output("#{bin}/bluepill -h")
    assert_match "Usage:", shell_output("#{bin}/bp -h")
  end
end
