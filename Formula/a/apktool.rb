class Apktool < Formula
  desc "Tool for reverse engineering 3rd party, closed, binary Android apps"
  homepage "https://github.com/iBotPeaches/Apktool"
  url "https://github.com/iBotPeaches/Apktool/releases/download/v2.8.1/apktool_2.8.1.jar"
  sha256 "7b4a8e1703e228d206db29644b71141687d8a111b55b039b08b02dfa443ab0f9"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "602be1a15bab5d61bd0723ca657dada6d1fad0e0049ef555072ae2e896f48fa2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "602be1a15bab5d61bd0723ca657dada6d1fad0e0049ef555072ae2e896f48fa2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "602be1a15bab5d61bd0723ca657dada6d1fad0e0049ef555072ae2e896f48fa2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "602be1a15bab5d61bd0723ca657dada6d1fad0e0049ef555072ae2e896f48fa2"
    sha256 cellar: :any_skip_relocation, sonoma:         "602be1a15bab5d61bd0723ca657dada6d1fad0e0049ef555072ae2e896f48fa2"
    sha256 cellar: :any_skip_relocation, ventura:        "602be1a15bab5d61bd0723ca657dada6d1fad0e0049ef555072ae2e896f48fa2"
    sha256 cellar: :any_skip_relocation, monterey:       "602be1a15bab5d61bd0723ca657dada6d1fad0e0049ef555072ae2e896f48fa2"
    sha256 cellar: :any_skip_relocation, big_sur:        "602be1a15bab5d61bd0723ca657dada6d1fad0e0049ef555072ae2e896f48fa2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "75ad278e46b40ea2f7b08e262d30520b7f04ede9d3760291ae5a674454f46ed7"
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
