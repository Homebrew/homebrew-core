class Apktool < Formula
  desc "Tool for reverse engineering 3rd party, closed, binary Android apps"
  homepage "https://apktool.org"
  url "https://github.com/iBotPeaches/Apktool/releases/download/v3.0.3/apktool_3.0.3.jar"
  sha256 "dbf930b076c6b9be08d57c449cacefc3bdd6b71ebd59b3066fc0e1f5b14f9423"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "9a376927a5c810db5be63363485bfe4fb51cd0d6774a617b5ae37522a4d55300"
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
