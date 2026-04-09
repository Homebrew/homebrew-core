class Apktool < Formula
  desc "Tool for reverse engineering 3rd party, closed, binary Android apps"
  homepage "https://github.com/iBotPeaches/Apktool"
  url "https://github.com/iBotPeaches/Apktool/releases/download/v3.0.1/apktool_3.0.1.jar"
  sha256 "b947b945b4bc455609ba768d071b64d9e63834079898dbaae15b67bf03bcd362"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "6981e2ad6eaa56df54316a3765b9bf357dca76e2f965f795bdc204c5cd9b64c6"
  end

  depends_on "openjdk"

  def install
    libexec.install "apktool_#{version}.jar"
    bin.write_jar_script libexec/"apktool_#{version}.jar", "apktool"
  end

  test do
    resource "homebrew-test.apk" do
      url "https://raw.githubusercontent.com/iBotPeaches/Apktool/v3.0.1/brut.apktool/apktool-lib/src/test/resources/issue1157/issue1157.apk"
      sha256 "b3159fd172d39c6b73d1c0f18e31ceeaf1fe25c638e8946eb1a9af9432e1fd24"
    end

    resource("homebrew-test.apk").stage do
      system bin/"apktool", "d", "issue1157.apk"
      # apktool b doesn't work on ARM Linux
      return if OS.linux? && Hardware::CPU.arm?

      system bin/"apktool", "b", "issue1157"
      assert_path_exists "issue1157/dist/issue1157.apk"
    end
  end
end
