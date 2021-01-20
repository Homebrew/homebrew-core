class Bluepill < Formula
  desc "Testing tool for iOS that runs UI tests using multiple simulators"
  homepage "https://github.com/linkedin/bluepill"
  url "https://github.com/linkedin/bluepill.git",
      tag:      "v5.6.0",
      revision: "ca19302bfbc48e1cf0ccf28eaad431abc6f78582"
  license "BSD-2-Clause"
  head "https://github.com/linkedin/bluepill.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "d7962bc6a7cebe51127a8195f15562298749880004a29ecc5f7ce688ff59a8d7" => :arm64_big_sur
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
