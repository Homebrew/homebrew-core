class Blueutil < Formula
  desc "Get/set bluetooth power and discoverable state"
  homepage "https://github.com/toy/blueutil"
  url "https://github.com/toy/blueutil/archive/refs/tags/v2.13.0.tar.gz"
  sha256 "d6beba603ab6638f72d9966aed33343f35cac441fc48a81c04fd532c844f170d"
  license "MIT"
  head "https://github.com/toy/blueutil.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c31d3a14d7db9bebfd0bc6db63cc175189c6bb715891a6f5b0bd4618f06f06b7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2d1d787bfda0fa2f1ed869851341fed5aec241e9910d49cf68d2fc45fb63b497"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6cbfdc8b46cdde4d61bbf221aa5a434e9320d30df95e930f0365d38709eab349"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "23f8456a3b7b9cce7e3f34b60ffa75727b58d772e552af3e0f7aea4627524daa"
    sha256 cellar: :any_skip_relocation, sonoma:        "2cff703f1c4f5826686dc1c948187a94b9130f9f367ec53fb765a193c953b602"
    sha256 cellar: :any_skip_relocation, ventura:       "ca2cecb2e1d3c5138a89baff635c957a43f9bf019ad598d7b6c149f95f26a5cf"
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
