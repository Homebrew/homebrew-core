class Bluepill < Formula
  desc "iOS testing tool that runs UI tests using multiple simulators"
  homepage "https://github.com/linkedin/bluepill"
  url "https://github.com/linkedin/bluepill/archive/v3.1.1.tar.gz"
  sha256 "35666939199643261cd50ec1044fc978a1835e3c77fe6cb0e3d49b4567d7ed26"
  head "https://github.com/linkedin/bluepill.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "8383eda347023b518d5b856621c1766547a44e520b79eaca417ffc957c8fb0b1" => :mojave
    sha256 "0482489f804ea434f842457362f2f49c7ea9a0d158f2c54710337dcdc2a1dc70" => :high_sierra
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
