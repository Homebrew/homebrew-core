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

  def install
    system "make", "install", "prefix=#{prefix}"
  end

  test do
    File.write(testpath/"Brew-Eula.txt", "Eula")
    (testpath/"Test-Source").mkpath
    (testpath/"Test-Source/Brew.app").mkpath
    system bin/"create-dmg", "--sandbox-safe", "--eula",
           testpath/"Brew-Eula.txt", testpath/"Brew-Test.dmg", testpath/"Test-Source"
  end
end
