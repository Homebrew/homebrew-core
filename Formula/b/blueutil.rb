class Blueutil < Formula
  desc "Get/set bluetooth power and discoverable state"
  homepage "https://github.com/toy/blueutil"
  url "https://github.com/toy/blueutil/archive/refs/tags/v2.12.0.tar.gz"
  sha256 "944d5d1a3003a453e5c6eb05e860185763f4898c6e419a3858d981743f88afcd"
  license "MIT"
  head "https://github.com/toy/blueutil.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aed3c4cc18a795d9b00d44c727e304e95a30d779adf1a3f5516c5ef919d2222d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c3194c8488aadf7c368c147dfd1123f6079ce1a355f749fc985661e14d9655d5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "df4282fa2f6747837f20f66be1d38f3347544f4a17a5322beceff985febe1a59"
    sha256 cellar: :any_skip_relocation, sonoma:        "851da7f3bef7af931468e91562285943c756c851bf2692cd1df4d20e444f0e66"
    sha256 cellar: :any_skip_relocation, ventura:       "cf1441c45a6e73cf3476a342a6c9e376d7a7024916269e69ee7c67500b5e36ed"
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
