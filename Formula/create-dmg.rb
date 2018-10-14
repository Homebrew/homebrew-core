class CreateDmg < Formula
  desc "A shell script to build fancy DMGs"
  homepage "https://github.com/andreyvit/create-dmg"
  url "https://github.com/andreyvit/create-dmg/releases/tag/v1.0.0.3"
  sha256 "4557de44fca40e22c0d44b89fcb722d1dc6e6df73049c7756675d4793bf1c9e2"

  def install
    bin.install "create-dmg"
  end

  test do
    system "#{bin}/create-dmg",
      "--volname \"Application Installer\"",
      "--volicon \"application\_icon.icns\"",
      "--background \"installer\_background.png\"",
      "--window-pos 200 120",
      "--window-size 800 400",
      "--icon-size 100",
      "--icon Application.app 200 190",
      "--hide-extension Application.app",
      "--app-drop-link 600 185",
      "Application-Installer.dmg",
      "."
    system "open", "Application-Installer.dmg"
  end
end
