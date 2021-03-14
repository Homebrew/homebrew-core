class Imagesnap < Formula
  desc "Tool to capture still images from an iSight or other video source"
  homepage "https://github.com/rharder/imagesnap"
  url "https://github.com/rharder/imagesnap/archive/0.2.12.tar.gz"
  sha256 "34ba713a79b7e0598bd598441dc2ba4045cf503e13f14e71575ead5bc5257c7d"
  license :public_domain

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "ebfb743c7906551d097ce5847530ae24f8732b0269598cb96d7ac0b9332d78cd"
    sha256 cellar: :any_skip_relocation, big_sur:       "b8a2f5bf975f5bcc20d37c41881de1fdcb7be16545f57167be1389952b4784e0"
    sha256 cellar: :any_skip_relocation, catalina:      "05549902e034a23f59473f94c30bacd395f0f0875da6349f24f42fb096ab06ed"
    sha256 cellar: :any_skip_relocation, mojave:        "32dab2f556c6b7fdea3ef91635ea8527ba50bf58c59002c635c50fcd7d6b698d"
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
