class Bluepill < Formula
  desc "iOS testing tool that runs UI tests using multiple simulators"
  homepage "https://github.com/linkedin/bluepill"
  url "https://github.com/linkedin/bluepill/archive/v0.2.2.tar.gz"
  sha256 "51498393b0a59619a3adc624439abf116225d5d2666f7aae9390c2e4f8e88475"
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
