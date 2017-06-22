class Bluepill < Formula
  desc "iOS testing tool that runs UI tests using multiple simulators"
  homepage "https://github.com/linkedin/bluepill"
  url "https://github.com/linkedin/bluepill/archive/v1.1.2.tar.gz"
  sha256 "bb6befddcad369ada6567d6f5fe9c57b7b16dd603467cb9e2d432098018a1e82"
  head "https://github.com/linkedin/bluepill.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "e6e37900e460cd9f592bd264ce2134c55408c66c011b4973650f54ab752c3405" => :sierra
    sha256 "3978c64e6553e9185fb2a0d27629736fcfbfd4c34efa3092a5a0e8e9e2affa66" => :el_capitan
  end

  depends_on :macos => :el_capitan # needed for xcode 8
  depends_on :xcode => :build

  def install
    xcodebuild "-workspace", "Bluepill.xcworkspace",
               "-scheme", "bluepill",
               "-configuration", "Release",
               "SYMROOT=../",
               "DSTROOT=../dstroot"
    bin.install "dstroot/usr/local/bin/bluepill"
    bin.install "dstroot/usr/local/bin/bp"
  end

  test do
    assert_match "Usage:", shell_output("#{bin}/bluepill -h")
    assert_match "Usage:", shell_output("#{bin}/bp -h")
  end
end
