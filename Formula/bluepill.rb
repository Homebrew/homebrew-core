class Bluepill < Formula
  desc "iOS testing tool that runs UI tests using multiple simulators"
  homepage "https://github.com/linkedin/bluepill"
  url "https://github.com/linkedin/bluepill/archive/v2.1.0.tar.gz"
  sha256 "5cf831caa8af1c53060976e74b4998241e1a9d3fb299bfe644a2312e07b8762b"
  head "https://github.com/linkedin/bluepill.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "980d5a25230ceafedcbf1b6e6c0dc20f72bbd1db33fb1e0c68a4f4c4718ed485" => :high_sierra
    sha256 "d5b0ea149d04431fddb399585d57bcd09faaa33572a4a5803ec2ac6a1cc29185" => :sierra
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
