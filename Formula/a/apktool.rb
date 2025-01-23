class Apktool < Formula
  desc "Tool for reverse engineering 3rd party, closed, binary Android apps"
  homepage "https://github.com/iBotPeaches/Apktool"
  url "https://github.com/iBotPeaches/Apktool/releases/download/v2.11.0/apktool_2.11.0.jar"
  sha256 "8fdc17c6fe2e6d80d71b8718eb2a5d0379f1cc7139ae777f6a499ce397b26f54"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "918b624637434a0e5c47c1f28e6962c5dec27439e5381631a31c90eb708973a8"
  end

  depends_on "openjdk"

  resource "homebrew-test.apk" do
    url "https://raw.githubusercontent.com/facebook/redex/fa32d542d4074dbd485584413d69ea0c9c3cbc98/test/instr/redex-test.apk"
    sha256 "7851cf2a15230ea6ff076639c2273bc4ca4c3d81917d2e13c05edcc4d537cc04"
  end

  def install
    libexec.install "apktool_#{version}.jar"
    bin.write_jar_script libexec/"apktool_#{version}.jar", "apktool"
  end

  test do
    resource("homebrew-test.apk").stage do
      system bin/"apktool", "d", "redex-test.apk"
      system bin/"apktool", "b", "redex-test"
    end
  end
end
