class Bluepill < Formula
  desc "iOS testing tool that runs UI tests using multiple simulators"
  homepage "https://github.com/linkedin/bluepill"
  url "https://github.com/linkedin/bluepill/archive/v1.0.0.tar.gz"
  sha256 "8f1e614a97e77389494dd9a54e0eb5c53cd874c4af0c96a168fdcc2d0171a2a2"
  head "https://github.com/linkedin/bluepill.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "d1476b622d37b94a1d82976820f8385480988cc867e18d424ae83ae5fe0bb8b9" => :sierra
    sha256 "777d93fccc6a19c77d395e960a5f4b1d21a26dd2d3422913efd965e9c94fc15c" => :el_capitan
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
