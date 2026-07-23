class Imagesnap < Formula
  desc "Tool to capture still images from an iSight or other video source"
  homepage "https://github.com/rharder/imagesnap"
  url "https://github.com/rharder/imagesnap/archive/refs/tags/0.3.0.2.tar.gz"
  sha256 "817660df5a5517c01d5672f28245050e8df12ef5006e98865bdcf07e6338dca4"
  license :public_domain

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d59cd3c3798012ad8f12a0863c9322a49656f73ee1f5d04962dfdea8a6add3e9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4d767be939443e84d120972d4a49d835d9b2759d7566f98f3a663ce115e1db81"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "912fe80ac50fea0fec8e88b5d043f0b52caf50e9c82b838f4a3901b64a02f668"
    sha256 cellar: :any_skip_relocation, sonoma:        "fb4e408a66aa05b67c4bab3d043eceff18d6537d574df60891654b653f2bfada"
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
