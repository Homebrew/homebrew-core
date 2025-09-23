class Apktool < Formula
  desc "Tool for reverse engineering 3rd party, closed, binary Android apps"
  homepage "https://github.com/iBotPeaches/Apktool"
  url "https://github.com/iBotPeaches/Apktool/releases/download/v2.12.0/apktool_2.12.0.jar"
  sha256 "effb69dab2f93806cafc0d232f6be32c2551b8d51c67650f575e46c016908fdd"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "e06dc74d6427a78ae5e00c80a352b5d69d7567670000bbb4030be5c407dd9a1c"
  end

  depends_on "openjdk"

  def install
    libexec.install "apktool_#{version}.jar"
    bin.write_jar_script libexec/"apktool_#{version}.jar", "apktool"
  end

  test do
    resource "homebrew-test.apk" do
      url "https://raw.githubusercontent.com/facebook/redex/fa32d542d4074dbd485584413d69ea0c9c3cbc98/test/instr/redex-test.apk"
      sha256 "7851cf2a15230ea6ff076639c2273bc4ca4c3d81917d2e13c05edcc4d537cc04"
    end

    resource("homebrew-test.apk").stage do
      system bin/"apktool", "d", "redex-test.apk"
      system bin/"apktool", "b", "redex-test"
    end
  end
end
