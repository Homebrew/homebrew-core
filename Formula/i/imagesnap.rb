class Imagesnap < Formula
  desc "Tool to capture still images from an iSight or other video source"
  homepage "https://github.com/rharder/imagesnap"
  url "https://github.com/rharder/imagesnap/archive/refs/tags/0.3.1.tar.gz"
  sha256 "47bea0dd3c9a3bb2d73e21ebde0eab9455232abf6fe0a8cd71742aa902f8a46e"
  license :public_domain

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "bf6cd6e70f21b1bf55902c0cb9401f7af4cf97d512c2a57f02f72ff1b68b3d46"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "ef14e72a32a94cbdc77a1a3c22ab4ef21cd062d59749175e0eb9f385be224326"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "09c88203caee699ca8f83b7242e4a4f20361c2fd444283f827682ab3e30cff08"
  end

  depends_on xcode: :build
  depends_on :macos

  def install
    xcodebuild "-arch", Hardware::CPU.arch, "-project", "ImageSnap.xcodeproj", "SYMROOT=build",
"MACOSX_DEPLOYMENT_TARGET=#{MacOS.version}"
    bin.install "build/Release/imagesnap"
  end

  test do
    assert_match "imagesnap", shell_output("#{bin}/imagesnap -h")
  end
end
