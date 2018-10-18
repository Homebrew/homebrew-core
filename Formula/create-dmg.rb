class CreateDmg < Formula
  desc "Shell script to build fancy DMGs"
  homepage "https://github.com/andreyvit/create-dmg"
  url "https://github.com/andreyvit/create-dmg/archive/v1.0.0.4.tar.gz"
  sha256 "e91fc0fa9ff6938ac81352a4c3ce347fefa18a780e00020096ef1d5636ba0c9b"

  def install
    system "support/brew-me.sh"
    bin.install "create-dmg"
  end

  test do
    (testpath/"Test-Source").mkpath
    (testpath/"Test-Source/Brew.app").mkpath
    system "#{bin}/create-dmg", testpath/"Brew-Test.dmg", testpath/"Test-Source"
  end
end
