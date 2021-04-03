class Bluepill < Formula
  desc "Testing tool for iOS that runs UI tests using multiple simulators"
  homepage "https://github.com/linkedin/bluepill"
  url "https://github.com/linkedin/bluepill.git",
      tag:      "v5.8.0",
      revision: "e2bca52fc54b5c3088ab31c7696c152a4dcbc984"
  license "BSD-2-Clause"
  head "https://github.com/linkedin/bluepill.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "7ca7c32184cd08ab55841420f1f58407c33115cd82e294ca956c8e80cd24cac5"
    sha256 cellar: :any_skip_relocation, big_sur:       "769f83b81752afc1a3745b53a0b376f70599e442d4b339907ab1d3eb6d1d008c"
    sha256 cellar: :any_skip_relocation, catalina:      "805b6b48c9e3e55b7cfd46520cf32ac50ddcdd33ce3d2f43a382d667af7baef2"
    sha256 cellar: :any_skip_relocation, mojave:        "ab69ae6197856ab156fe5b22d98a7318b7c7389f3075c62ef49cb634fdef4d0b"
  end

  depends_on xcode: ["11.2", :build]
  depends_on :macos

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
