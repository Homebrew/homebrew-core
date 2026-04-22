class Apktool < Formula
  desc "Tool for reverse engineering 3rd party, closed, binary Android apps"
  homepage "https://github.com/iBotPeaches/Apktool"
  url "https://github.com/iBotPeaches/Apktool/releases/download/v3.0.2/apktool_3.0.2.jar"
  sha256 "eee4669a704a14e0623407e6701b0b91887e61e1e4049cb7a82833e14ae8b5fd"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "fb33fa9a035994fa636fe6e677f4adc8fb222feb42ca2e7b2cc5c90e0e29d44e"
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
