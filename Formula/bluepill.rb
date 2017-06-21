class Bluepill < Formula
  desc "iOS testing tool that runs UI tests using multiple simulators"
  homepage "https://github.com/linkedin/bluepill"
  url "https://github.com/linkedin/bluepill/archive/v1.1.2.tar.gz"
  sha256 "bb6befddcad369ada6567d6f5fe9c57b7b16dd603467cb9e2d432098018a1e82"
  head "https://github.com/linkedin/bluepill.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "63daed2006327981bc5ecf18de42219407fb93f9dc7f86654ec1b29717da3507" => :sierra
    sha256 "bddc12777032e1c3d6efbf4f7f80f23b2d914bcd21ed9175f150f611d8ac547f" => :el_capitan
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
