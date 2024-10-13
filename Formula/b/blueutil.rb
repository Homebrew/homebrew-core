class Blueutil < Formula
  desc "Get/set bluetooth power and discoverable state"
  homepage "https://github.com/toy/blueutil"
  url "https://github.com/toy/blueutil/archive/refs/tags/v2.10.0.tar.gz"
  sha256 "1558977dd4095ff89768a2f7eaff765e760b56c736a9cd5956b1227ebfee8f2b"
  license "MIT"
  head "https://github.com/toy/blueutil.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "061e8edbdab4c9da236494c79209543a8cb679f00e815966456c1b314bcdfbf5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "02e1c9fad6e8b343d5b9e15a4aa0c4b853a1d2b1dac339d01da0b01fcbad86de"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d0c09f20aad162c559723b5c883c63db270c2cb60005283b170f629de63f8313"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a9f5aa947b307b1983cdfe545d47884074364a0db4a912891ca0d0ab4f20f843"
    sha256 cellar: :any_skip_relocation, sonoma:         "2faeff79878497b5db013e243f8f2a88f54c1932a1df1ab422a671d472ebfd43"
    sha256 cellar: :any_skip_relocation, ventura:        "288321f9b4d1e1bdd7371dfd70f3faaa5ef87fd8ca19f68a6062cd4d6789f97b"
    sha256 cellar: :any_skip_relocation, monterey:       "d2d9405fa33c97ca5f9fdbac3e287c44902d97a7c80becf152eb6177f2c33163"
  end

  depends_on xcode: :build
  depends_on :macos

  def install
    # Set to build with SDK=macosx10.6, but it doesn't actually need 10.6
    xcodebuild "-arch", Hardware::CPU.arch,
               "SDKROOT=",
               "SYMROOT=build",
               "MACOSX_DEPLOYMENT_TARGET=#{MacOS.version}"
    bin.install "build/Release/blueutil"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/blueutil --version")
    # We cannot test any useful command since Sonoma as OS privacy restrictions
    # will wait until Bluetooth permission is either accepted or rejected.
    system bin/"blueutil", "--discoverable", "0" if MacOS.version < :sonoma
  end
end
