class Imagesnap < Formula
  desc "Tool to capture still images from an iSight or other video source"
  homepage "https://iharder.sourceforge.io/current/macosx/imagesnap/"
  url "https://github.com/rharder/imagesnap/archive/0.2.6.tar.gz"
  sha256 "e55c9f8c840c407b7441c16279c39e004f6225b96bb64ff0c2734da18a759033"
  license :public_domain

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "3d5eddf9c53f7dab46ab883f3961cef4f78cdc7b488c500106b4a30fa12930a5"
    sha256 cellar: :any_skip_relocation, big_sur:       "ec9348dab5dc28d80e546b7e6acd8c8b6413ce0e4be46e33d4a33d9676f05a7a"
    sha256 cellar: :any_skip_relocation, catalina:      "eb2508bd4f64b4c7de5e3f7e356ecd93e916a0578486e64a7049bcfbadab5823"
    sha256 cellar: :any_skip_relocation, mojave:        "f42749a98de36c1f8e803024ed7e59cab3ea14ac639ced0695eed661e6a546ba"
  end

  depends_on xcode: :build

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
    xcodebuild "-project", "ImageSnap.xcodeproj", "SYMROOT=build"
    bin.install "build/Release/imagesnap"
  end

  test do
    assert_match "imagesnap", shell_output("#{bin}/imagesnap -h")
  end
end
