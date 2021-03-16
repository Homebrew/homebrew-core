class Imagesnap < Formula
  desc "Tool to capture still images from an iSight or other video source"
  homepage "https://github.com/rharder/imagesnap"
  url "https://github.com/rharder/imagesnap/archive/0.2.12.tar.gz"
  sha256 "34ba713a79b7e0598bd598441dc2ba4045cf503e13f14e71575ead5bc5257c7d"
  license :public_domain

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "18669a90a51230e2bdd331646376a9d253a70887f7d0bc5026f3ae8d80e99c2c"
    sha256 cellar: :any_skip_relocation, big_sur:       "9d376efb1d620a467c115484d22472555e630651c7a1b59423d6d4db9879b969"
    sha256 cellar: :any_skip_relocation, catalina:      "ca0082c02a7b09d664c91cf94bcf1dd9f181fcaf855c4152e2530b44bfd86d75"
    sha256 cellar: :any_skip_relocation, mojave:        "ebe22a833280f18db1a3c0045660ed59da9873b81b6543c354737c875bcaf2a4"
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
