class Bluepill < Formula
  desc "Testing tool for iOS that runs UI tests using multiple simulators"
  homepage "https://github.com/linkedin/bluepill"
  url "https://github.com/linkedin/bluepill.git",
    tag:      "v5.4.2",
    revision: "506e39951ea835b9240b15bd6a6bf593cf6534f9"
  license "BSD-2-Clause"
  head "https://github.com/linkedin/bluepill.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "860abd0b17f9b3ee0bab9960b8104d424de5127f6e338bb3f116f0dbe42ddcd5" => :catalina
    sha256 "36531d4a3b4689c44f1e2ace7a35ec6bfbcdbab6a61c5beef9be1bd393325284" => :mojave
  end

  depends_on xcode: ["11.2", :build]

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
