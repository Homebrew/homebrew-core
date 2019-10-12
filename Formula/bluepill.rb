class Bluepill < Formula
  desc "iOS testing tool that runs UI tests using multiple simulators"
  homepage "https://github.com/linkedin/bluepill"
  url "https://github.com/linkedin/bluepill.git",
    :tag => "v5.0.0"
  sha256 "9b147ccd040449f9a2a47c8cc884819eae098d93f7e987dce259982a729fd136"
  head "https://github.com/linkedin/bluepill.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "0f1689fe856c9d81ca3095c7567e8e7733d3534ef1dfa5b8d12777ec51f4d618" => :catalina
    sha256 "9429839c4f5c45f73fc81e6b601bcf058cdcbc2936a269125f04f59dfa6b6783" => :mojave
    sha256 "57c90a31f9e2e6d8bbe31ff1c183efa6d57c934e826be3e1c7f2c34b6a40928f" => :high_sierra
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
