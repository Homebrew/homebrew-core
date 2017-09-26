class Bluepill < Formula
  desc "iOS testing tool that runs UI tests using multiple simulators"
  homepage "https://github.com/linkedin/bluepill"
  url "https://github.com/linkedin/bluepill/archive/v2.0.0.tar.gz"
  sha256 "ac14147d60d568a2403a30066adb99547154c2814007f19390218b78c1e27ff8"
  head "https://github.com/linkedin/bluepill.git"

  bottle do
    cellar :any
    sha256 "5d4b18deb04e6580e07deafa649e6e10258aa753b0e904c8a7fd6aeb56f8cc7d" => :high_sierra
    sha256 "5aa90a8f0a5f960fbf848fb35b93f6540906e9e202fe6f59249e223e92a742d8" => :sierra
  end

  depends_on :xcode => ["9.0", :build]

  def install
    xcodebuild "-workspace", "Bluepill.xcworkspace",
               "-scheme", "bluepill",
               "-configuration", "Release",
               "SYMROOT=../"
    bin.install "Release/bluepill", "Release/bp"
  end

  test do
    assert_match "Usage:", shell_output("#{bin}/bluepill -h")
    assert_match "Usage:", shell_output("#{bin}/bp -h")
  end
end
