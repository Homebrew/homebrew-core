class Imagesnap < Formula
  desc "Tool to capture still images from an iSight or other video source"
  homepage "https://github.com/rharder/imagesnap"
  url "https://github.com/rharder/imagesnap/archive/refs/tags/0.2.16.tar.gz"
  sha256 "103610515aae71fe1eea6bea15b2b48542f88042515d404fb4d0a18f44120a9a"
  license :public_domain

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e01dfbebaf65a1205abbb47b938aa38f45aff14787b9ef5960ca4cacddbe5e73"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0683fa385f89f31a92f19329f134b79f1d097b7ce909bc6ecf4c6bc65562c9c4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4750f08883ae1846a3f5168242228e9b3e6678b5f16fb19e43b20a4d4861c17f"
    sha256 cellar: :any_skip_relocation, ventura:        "e5a9f0379ce4c9d831984b53c6f46c6d333dc949919b2a126ca9dee2ddebe441"
    sha256 cellar: :any_skip_relocation, monterey:       "8f742d6ca025a27ee2f88509b25bf3871ff52bfa0c4874ee3145d8bdf9f96c83"
    sha256 cellar: :any_skip_relocation, big_sur:        "a551ce7a2043379202376d8f7395ca0019771c41ecc07d8823f819300cb445ca"
  end

  depends_on xcode: :build
  depends_on :macos

  def install
    xcodebuild "-arch", Hardware::CPU.arch, "-project", "ImageSnap.xcodeproj", "SYMROOT=build"
    bin.install "build/Release/imagesnap"
  end

  test do
    assert_match "imagesnap", shell_output("#{bin}/imagesnap -h")
  end
end
