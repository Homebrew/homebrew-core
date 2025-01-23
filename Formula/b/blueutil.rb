class Blueutil < Formula
  desc "Get/set bluetooth power and discoverable state"
  homepage "https://github.com/toy/blueutil"
  url "https://github.com/toy/blueutil/archive/refs/tags/v2.11.0.tar.gz"
  sha256 "ac003fefe73a0655fc20101fc8c187cf9bcc172916780eb7da6c8d71b3194cfd"
  license "MIT"
  head "https://github.com/toy/blueutil.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "17ff09c0dd7ec77c78c54698beca6097c420840aa2c3d48d401b4906c9526a47"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8e76760d531bc3166b2ab12ba6d3ff4ea96fa15fbcc703cd81051c9ba9622f4e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1f0ad5bc847fd03e8907f32d9caf25a4062406743132caea967fe135be59400a"
    sha256 cellar: :any_skip_relocation, sonoma:        "118cb6fdc2a3afdfdfa933b3cd63fea9b5bc44cc94192a0712dbcaa582fb1899"
    sha256 cellar: :any_skip_relocation, ventura:       "aed2a592a1e886d1458b71d3829611a187a9773538143f970d74c543c0288626"
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
