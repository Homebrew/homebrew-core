class Bluepill < Formula
  desc "iOS testing tool that runs UI tests using multiple simulators"
  homepage "https://github.com/linkedin/bluepill"
  url "https://github.com/linkedin/bluepill/archive/v1.0.0.tar.gz"
  sha256 "8f1e614a97e77389494dd9a54e0eb5c53cd874c4af0c96a168fdcc2d0171a2a2"
  head "https://github.com/linkedin/bluepill.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "f679e90f16d001271159778d04ba2f9c27a8fa808155df73224fc8d05fc40eb0" => :sierra
    sha256 "ebd0403c2b8f38f099cb4ba99948043ad9e533e78a42db62ca0465369f80d67c" => :el_capitan
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
