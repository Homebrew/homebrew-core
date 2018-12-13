class CreateDmg < Formula
  desc "Shell script to build fancy DMGs"
  homepage "https://github.com/andreyvit/create-dmg"
  url "https://github.com/andreyvit/create-dmg/archive/v1.0.0.5.tar.gz"
  sha256 "de76c8a7a1f4705720d61d39de7c87b7bc2acc7c35f6ec8d6d2dbdafcedc21b6"

  bottle do
    cellar :any_skip_relocation
    sha256 "ac67784b7d07464213212fcccaa143fc680b2f4feb082d5f949c9557c1a5e118" => :mojave
    sha256 "768037ca1bd0d6d6fa3191ab7bb50a0d8ceb07aa5e5a76ccd0333d32dd1e93f4" => :high_sierra
    sha256 "768037ca1bd0d6d6fa3191ab7bb50a0d8ceb07aa5e5a76ccd0333d32dd1e93f4" => :sierra
  end

  def install
    system "support/brew-me.sh"
    bin.install "create-dmg"
  end

  test do
    File.write(testpath/"Brew-Eula.txt", "Eula")
    (testpath/"Test-Source").mkpath
    (testpath/"Test-Source/Brew.app").mkpath
    system "#{bin}/create-dmg", "--sandbox-safe", "--eula", testpath/"Brew-Eula.txt", testpath/"Brew-Test.dmg", testpath/"Test-Source"
  end
end
