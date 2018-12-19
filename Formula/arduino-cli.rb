class ArduinoCli < Formula
  desc "Arduino command-line interface"
  homepage "https://github.com/arduino/arduino-cli"
  url "https://github.com/arduino/arduino-cli/releases/download/0.3.3-alpha.preview/arduino-cli-0.3.3-alpha.preview-osx.zip"
  version "0.3.3-alpha"
  sha256 "cc5b2b53fba4b518ab3f3332635645f1149aef6e1a5a9a6e6b91ee2b382f49ad"

  def install
    mv "./arduino-cli-0.3.3-alpha.preview-osx", "./arduino-cli"
    bin.install "arduino-cli"
  end

  test do
    assert_equal "arduino-cli version #{version}.preview", shell_output("#{bin}/arduino-cli version").strip
    system "#{bin}/arduino-cli", "core", "search", "arduino"
  end
end
