class Bluepill < Formula
  desc "iOS testing tool that runs UI tests using multiple simulators"
  homepage "https://github.com/linkedin/bluepill"
  url "https://github.com/linkedin/bluepill/archive/1.1.0.tar.gz"
  sha256 "50c33976865244c1ebd181c374218bfa75d79f22baec3e16319250640f8625b7"
  head "https://github.com/linkedin/bluepill.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "a3525389f1615e4402eee3e77931b57caa057c7a11a592300950ae777f22aa10" => :sierra
    sha256 "5f836ca162fdbf43412bc45716da5842b74844c2d84bb9f12cf72ea07fac6916" => :el_capitan
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
