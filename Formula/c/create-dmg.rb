class CreateDmg < Formula
  desc "Shell script to build fancy DMGs"
  homepage "https://github.com/create-dmg/create-dmg"
  url "https://github.com/create-dmg/create-dmg/archive/refs/tags/v1.3.0.tar.gz"
  sha256 "c50d2bc97c3d6292642bac55f530d247eaf4bf65ee605f26b4caf339383e381c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "2a93e0121ce021f77b0861939f7186cfef43ffec154a5b53dc446138f7c28419"
  end

  depends_on :macos

  deny_network_access!

  def install
    system "make", "install", "prefix=#{prefix}"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/create-dmg --version")

    # The test sandbox blocks `hdiutil resize`/`attach`, so stop at the existing output check before imaging
    (testpath/"Test-Source/Brew.app").mkpath
    touch testpath/"Brew-Test.dmg"
    output = shell_output("#{bin}/create-dmg --sandbox-safe #{testpath}/Brew-Test.dmg #{testpath}/Test-Source", 1)
    assert_match "Output file already exists", output
  end
end
