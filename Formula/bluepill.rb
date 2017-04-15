class Bluepill < Formula
  desc "iOS testing tool that runs UI tests using multiple simulators"
  homepage "https://github.com/linkedin/bluepill"
  url "https://github.com/linkedin/bluepill/archive/v1.0.1.tar.gz"
  sha256 "7d8f568121dc0bff5bb5b1e1b595a68490729d6020df58c8ca9aca21f239be7d"
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
