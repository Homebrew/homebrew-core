class Imagesnap < Formula
  desc "Tool to capture still images from an iSight or other video source"
  homepage "https://iharder.sourceforge.io/current/macosx/imagesnap/"
  url "https://github.com/rharder/imagesnap/archive/0.2.7.tar.gz"
  sha256 "94832e7ec1e690046c71358cdd460106405b7bc333eba42960a3a5c5d47129d3"
  license :public_domain

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "c3a28b07aae6f9f8ef4576c15d5429da8f3191344b60eeb84da0908bc44ceb1a"
    sha256 cellar: :any_skip_relocation, big_sur:       "aa01a6a882185253bfe06a727d7ba2c6e15f8ebae6bed05b479cfd0ba16c7f00"
    sha256 cellar: :any_skip_relocation, catalina:      "b66463b0af39b7bc1b2d089d3a809f8ea1c2001dbdaaafa423a5c0ed18d9914a"
    sha256 cellar: :any_skip_relocation, mojave:        "ff13ade6a1e91b84b4800c8b56ce73b3ebb3ce25c5341dc6e9dbae2f35afb410"
  end

  depends_on xcode: :build

  def install
    xcodebuild "-project", "ImageSnap.xcodeproj", "SYMROOT=build"
    bin.install "build/Release/imagesnap"
  end

  test do
    assert_match "imagesnap", shell_output("#{bin}/imagesnap -h")
  end
end
