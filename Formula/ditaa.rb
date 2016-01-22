class Ditaa < Formula
  desc "Convert ASCII diagrams into proper bitmap graphics"
  homepage "http://ditaa.sourceforge.net/"
  url "https://github.com/stathissideris/ditaa/archive/v0.10.tar.gz"
  sha256 "82e49065d408cba8b323eea0b7f49899578336d566096c6eb6e2d0a28745d63b"

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
