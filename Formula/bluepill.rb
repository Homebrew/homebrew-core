class Bluepill < Formula
  desc "iOS testing tool that runs UI tests using multiple simulators"
  homepage "https://github.com/linkedin/bluepill"
  url "https://github.com/linkedin/bluepill/archive/3.1.0.tar.gz"
  sha256 "9fe609d15cb6329df9cb02f1360b895e873f70816b13c2cb4c0ca6dd7641a9c5"
  head "https://github.com/linkedin/bluepill.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "af2886f24850d692c16da75dff3d59034b46bc0b455ec61ca031155f215600db" => :high_sierra
    sha256 "a5fb40247ab03c018bf249dc9ec665f57e328c28afb1fbcda6cff9d739888968" => :sierra
  end

  depends_on :xcode => ["10.0", :build]

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
