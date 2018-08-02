class Imagesnap < Formula
  desc "Tool to capture still images from an iSight or other video source"
  homepage "https://iharder.sourceforge.io/current/macosx/imagesnap/"
  url "https://github.com/rharder/imagesnap/archive/0.2.6.tar.gz"
  sha256 "e55c9f8c840c407b7441c16279c39e004f6225b96bb64ff0c2734da18a759033"

  bottle do
    cellar :any_skip_relocation
    sha256 "aad1fdf9cd4f97e787fe909e1edd5b303ed79db9d1ef4749fc4096fa26301feb" => :high_sierra
    sha256 "bfee8ffebe9c16cbd6d33de6e39d2e1661f76a5211c625fedf49c7c77da360aa" => :sierra
    sha256 "02a2db58a63115170c3cfae52c8a6b6b15ffa8bebee81254dc5624aeea375899" => :el_capitan
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
