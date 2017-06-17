class Bluepill < Formula
  desc "iOS testing tool that runs UI tests using multiple simulators"
  homepage "https://github.com/linkedin/bluepill"
  url "https://github.com/linkedin/bluepill/archive/v1.1.1.tar.gz"
  sha256 "4435c92b090f604050b5aacda0d1b4456d812279fae904cb227b14370d13a949"
  head "https://github.com/linkedin/bluepill.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "c89ffe9acf96401cfa6d08ccfc88c14b140d9387c46a5b0641ce60fe6ac4c65b" => :sierra
    sha256 "be3d6860bfa24a53b2398177b618a0ac2f4e2e6bf87bf869d8ce4f3529bf9b43" => :el_capitan
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
