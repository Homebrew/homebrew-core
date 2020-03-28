class Bluepill < Formula
  desc "iOS testing tool that runs UI tests using multiple simulators"
  homepage "https://github.com/linkedin/bluepill"
  url "https://github.com/linkedin/bluepill.git",
    :tag => "v5.2.0", :revision => "c59e6a46ef0d34314fba9586920ce8c8b4609d09"
  head "https://github.com/linkedin/bluepill.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "27d702355cc348c0ab88be40cb57fa12abbec3ee9ed980d437926e073c274a4f" => :catalina
    sha256 "6c06e7ad31f2284667844a386cd3f196001b4365f23f3da75430f5aede13d3e5" => :mojave
  end

  depends_on :xcode => ["11.2", :build]

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
