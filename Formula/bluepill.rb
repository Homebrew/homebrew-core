class Bluepill < Formula
  desc "iOS testing tool that runs UI tests using multiple simulators"
  homepage "https://github.com/linkedin/bluepill"
  url "https://github.com/linkedin/bluepill/archive/v2.1.0.tar.gz"
  sha256 "5cf831caa8af1c53060976e74b4998241e1a9d3fb299bfe644a2312e07b8762b"
  head "https://github.com/linkedin/bluepill.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "3e67c31f8dfe739788e7078e5220e91ebfd956a290803c8e62167ad26d8ad909" => :high_sierra
    sha256 "449c426e4d287ba952845568f79f1df59d7c21c6bf85716f745a68db5ff24fe1" => :sierra
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
