class Bluepill < Formula
  desc "iOS testing tool that runs UI tests using multiple simulators"
  homepage "https://github.com/linkedin/bluepill"
  url "https://github.com/linkedin/bluepill/archive/1.1.0.tar.gz"
  sha256 "50c33976865244c1ebd181c374218bfa75d79f22baec3e16319250640f8625b7"
  head "https://github.com/linkedin/bluepill.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "e6f56d165d161e6272666278276d869c81982cac38259132d9aef7dee0a9da97" => :sierra
    sha256 "bd5009b95eb5520123e3bd9fd6a37b3e9f6ee7cfdc24fc64f81686706e86800c" => :el_capitan
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
