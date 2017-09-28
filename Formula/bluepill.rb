class Bluepill < Formula
  desc "iOS testing tool that runs UI tests using multiple simulators"
  homepage "https://github.com/linkedin/bluepill"
  url "https://github.com/linkedin/bluepill/archive/v2.0.1.tar.gz"
  sha256 "fd6651ce8731dc81080e015f3cf56fb3875a309db955acd163f6661d22c22dde"
  head "https://github.com/linkedin/bluepill.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "0a1a817f0006dd346b1d8c2c8bac79316297f1d6e5aeacacfe7302ea2b49fec2" => :high_sierra
    sha256 "fba06c11d46c15d1ecaf6914e90799ef596af088a50a98ce916a5cdd47fe93a7" => :sierra
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
