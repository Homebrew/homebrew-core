class Apktool < Formula
  desc "Tool for reverse engineering 3rd party, closed, binary Android apps"
  homepage "https://github.com/iBotPeaches/Apktool"
  url "https://github.com/iBotPeaches/Apktool/releases/download/v2.9.0/apktool_2.9.0.jar"
  sha256 "e5ecf759297b845be64a3a5145ccc372db905b15a801a22ea1c91ee03c4c7a65"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c2b6082903913bc1a509984ee0111dfa77ea9add070379ff665023b8e043958f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c2b6082903913bc1a509984ee0111dfa77ea9add070379ff665023b8e043958f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c2b6082903913bc1a509984ee0111dfa77ea9add070379ff665023b8e043958f"
    sha256 cellar: :any_skip_relocation, sonoma:         "c2b6082903913bc1a509984ee0111dfa77ea9add070379ff665023b8e043958f"
    sha256 cellar: :any_skip_relocation, ventura:        "c2b6082903913bc1a509984ee0111dfa77ea9add070379ff665023b8e043958f"
    sha256 cellar: :any_skip_relocation, monterey:       "c2b6082903913bc1a509984ee0111dfa77ea9add070379ff665023b8e043958f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cf48bb5ce93744b860bda4b4985df7ef5a1fb2d186ce33c22c05272013019611"
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
