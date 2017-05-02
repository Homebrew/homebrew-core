class Bluepill < Formula
  desc "iOS testing tool that runs UI tests using multiple simulators"
  homepage "https://github.com/linkedin/bluepill"
  url "https://github.com/linkedin/bluepill/archive/v1.0.1.tar.gz"
  sha256 "7d8f568121dc0bff5bb5b1e1b595a68490729d6020df58c8ca9aca21f239be7d"
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
