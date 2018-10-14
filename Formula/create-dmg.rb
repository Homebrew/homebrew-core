class CreateDmg < Formula
  desc "Shell script to build fancy DMGs"
  homepage "https://github.com/andreyvit/create-dmg"
  url "https://github.com/andreyvit/create-dmg/archive/v1.0.0.4.tar.gz"
  sha256 "bebc5fa200e55d8c792cb92699a0c4ba73e7dc7d4baf9814831f6963d0be589d"

  def install
    bin.install "create-dmg"
    include.install "support/dmg-license.py"
    include.install "support/template.applescript"
  end

  test do
    (testpath/"Test-Source").mkpath
    (testpath/"Test-Source/Brew.app").mkpath
    system "#{bin}/create-dmg", testpath/"Brew-Test.dmg", testpath/"Test-Source"
  end
end
