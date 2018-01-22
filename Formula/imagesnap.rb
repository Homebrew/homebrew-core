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

  def install
    xcodebuild "-project", "ImageSnap.xcodeproj", "SYMROOT=build", "-sdk", MacOS.sdk_path
    bin.install "build/Release/imagesnap"
  end

  test do
    assert_match "imagesnap", shell_output("#{bin}/imagesnap -h")
  end
end
