class Bluepill < Formula
  desc "iOS testing tool that runs UI tests using multiple simulators"
  homepage "https://github.com/linkedin/bluepill"
  url "https://github.com/linkedin/bluepill/archive/v2.2.0.tar.gz"
  sha256 "dee98d7ff14b7488ea63b3af763879d98ca25c380549024edf9c57eb62660b0d"
  head "https://github.com/linkedin/bluepill.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "7d099b7cc67899b21aac9ee60dc701327319e80a0548dada52f2ec0a5d1c4460" => :high_sierra
    sha256 "0d08ff307d268aad1f24ef11ffd960e2f64a1dc0551e6bbced4524f3db24506f" => :sierra
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
