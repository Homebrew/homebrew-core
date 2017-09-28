class Bluepill < Formula
  desc "iOS testing tool that runs UI tests using multiple simulators"
  homepage "https://github.com/linkedin/bluepill"
  url "https://github.com/linkedin/bluepill/archive/v2.0.1.tar.gz"
  sha256 "fd6651ce8731dc81080e015f3cf56fb3875a309db955acd163f6661d22c22dde"
  head "https://github.com/linkedin/bluepill.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "78fa2bad43568c6c714e832ba25ce49bb8710cb7c277e86aeed38b1f47916467" => :high_sierra
    sha256 "763bcc6639b13a6fb457ad2565f3bbf6416ceb4df4c08b8c8b2b23b7862949e9" => :sierra
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
