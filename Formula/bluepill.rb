class Bluepill < Formula
  desc "iOS testing tool that runs UI tests using multiple simulators"
  homepage "https://github.com/linkedin/bluepill"
  url "https://github.com/linkedin/bluepill/archive/v3.0.1.tar.gz"
  sha256 "9586f4c8f2c0f04b91b6c50002bdb1c159edfacd3fbe1b98c428dba8aab0b026"
  head "https://github.com/linkedin/bluepill.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "af2886f24850d692c16da75dff3d59034b46bc0b455ec61ca031155f215600db" => :high_sierra
    sha256 "a5fb40247ab03c018bf249dc9ec665f57e328c28afb1fbcda6cff9d739888968" => :sierra
  end

  depends_on :xcode => ["9.0", :build]

  def install
    xcodebuild "-project", "Bluepill-cli/Bluepill-cli.xcodeproj",
               "-scheme", "BluepillLib ",
               "-configuration", "Release",
               "SYMROOT=../"
    bin.install "Release/bluepill", "Release/bp"
  end

  test do
    assert_match "Usage:", shell_output("#{bin}/bluepill -h")
    assert_match "Usage:", shell_output("#{bin}/bp -h")
  end
end
