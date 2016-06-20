class Ditaa < Formula
  desc "Convert ASCII diagrams into proper bitmap graphics"
  homepage "http://ditaa.sourceforge.net/"
  url "https://github.com/stathissideris/ditaa/archive/v0.10.tar.gz"
  sha256 "82e49065d408cba8b323eea0b7f49899578336d566096c6eb6e2d0a28745d63b"

  bottle do
    cellar :any_skip_relocation
    sha256 "b5b3b93c92efa5c50f7bfae9e625fbdd29098f768c695ff41e1cec32bdb28f3a" => :el_capitan
    sha256 "e0495f37f6c612a5684c5ac6a64f91617da90775ff6b0f61dbffdb7ead374a93" => :yosemite
    sha256 "2d4a0abeb8a7a5802555697c1cefddadf2e5c996b902a062dc6543d5968a8f3e" => :mavericks
  end

  depends_on :ant => :build
  depends_on :java

  def install
    # 0.10 Release still calls itself 0.9
    # Reported upstream at https://github.com/stathissideris/ditaa/issues/14
    inreplace "build/release.xml", "0_9", "0_10"
    inreplace "src/org/stathissideris/ascii2image/core/CommandLineConverter.java", "ditaa version 0.9", "ditaa version 0.10"

    mkdir "bin"
    system "ant", "-buildfile", "build/release.xml", "release-jar"
    libexec.install "releases/ditaa0_10.jar"
    bin.write_jar_script libexec/"ditaa0_10.jar", "ditaa"
  end

  test do
    system "#{bin}/ditaa", "-help"
  end
end
