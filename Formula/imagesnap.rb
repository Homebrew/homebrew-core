class Imagesnap < Formula
  desc "Tool to capture still images from an iSight or other video source"
  homepage "https://iharder.sourceforge.io/current/macosx/imagesnap/"
  url "https://github.com/rharder/imagesnap/archive/0.2.6.tar.gz"
  sha256 "e55c9f8c840c407b7441c16279c39e004f6225b96bb64ff0c2734da18a759033"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "472f24d660d9a7ca82041b10aac43250e44b84ebb469cf8d8f349b462bd3aaf4" => :catalina
    sha256 "f407afef9b42d250115f21c69a28a9e4fd143619d71cac9f4d92c0d17d3512ad" => :mojave
    sha256 "6b40f134d9180d7874db92f4a79dad69a74669791f13233e435eed8710c2f4d2" => :high_sierra
    sha256 "6cd7d838362754709f98d28c3fe45736f188bfdc8662cf1986089091c5d1e3d0" => :sierra
    sha256 "bbe0115174e191a6eaeedcdb3136e4c9248e7bab649bb30ddd4e07d27ea4e553" => :el_capitan
  end

  depends_on :xcode => :build

  # Fixes running on 10.13+: https://github.com/rharder/imagesnap/issues/16
  # Merged into master, will be in the next release.
  patch do
    url "https://github.com/rharder/imagesnap/commit/cd33ff8963006c37170872a7bdd0f29a7eae9a29.patch?full_index=1"
    sha256 "2747d93a27892fcc585e014365f6081e56904e23dcdb84c581ba94b0c061f41a"
  end

  # Fixes filename specification: https://github.com/rharder/imagesnap/issues/19
  # Merged into master, will be in the next release.
  patch do
    url "https://github.com/rharder/imagesnap/commit/c727968f278d09a792fd0dbbb19903c48518ba24.patch?full_index=1"
    sha256 "b43cb2be1a577a472af1bc990007411860c451c0bca9528340598eeb2cb36ff5"
  end

  def install
    xcodebuild "-project", "ImageSnap.xcodeproj", "SYMROOT=build", "-sdk", MacOS.sdk_path
    bin.install "build/Release/imagesnap"
  end

  test do
    assert_match "imagesnap", shell_output("#{bin}/imagesnap -h")
  end
end
