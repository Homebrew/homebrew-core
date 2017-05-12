class Bluepill < Formula
  desc "iOS testing tool that runs UI tests using multiple simulators"
  homepage "https://github.com/linkedin/bluepill"
  url "https://github.com/linkedin/bluepill/archive/v1.0.2.tar.gz"
  sha256 "7483fc6f312cb76200364c0a09d0895218e4f69349e9467338155684ec09aaab"
  head "https://github.com/linkedin/bluepill.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "a7e09b52470e9eab5b5162c8772380f15e0cbd4a5d1469e3eb7c4ffe1f756955" => :sierra
    sha256 "70e5c61b9dc318bb2fea072130b360b777ae85942f69a62e9069a868fb85348d" => :el_capitan
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
  end

  test do
    assert_match "Usage:", shell_output("#{bin}/bluepill -h")
  end
end
