class Bluepill < Formula
  desc "Testing tool for iOS that runs UI tests using multiple simulators"
  homepage "https://github.com/linkedin/bluepill"
  url "https://github.com/linkedin/bluepill.git",
    tag:      "v5.4.2",
    revision: "506e39951ea835b9240b15bd6a6bf593cf6534f9"
  license "BSD-2-Clause"
  head "https://github.com/linkedin/bluepill.git"

  livecheck do
    url "https://github.com/linkedin/bluepill/releases/latest"
    regex(%r{href=.*?/tag/v?(\d+(?:\.\d+)+)["' >]}i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "695be1e8867ff14019e9604f7350ba90be43dc7f7794fdc830ee3311595f6a6d" => :catalina
    sha256 "c99867b72bcaeb0198a69b7c957979b30ba0a6e4d9ca3b72dfa3ea27b50f2387" => :mojave
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
