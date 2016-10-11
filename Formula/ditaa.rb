class Ditaa < Formula
  desc "Convert ASCII diagrams into proper bitmap graphics"
  homepage "http://ditaa.sourceforge.net/"
  url "https://github.com/stathissideris/ditaa/archive/v0.10.tar.gz"
  sha256 "82e49065d408cba8b323eea0b7f49899578336d566096c6eb6e2d0a28745d63b"

  bottle do
    cellar :any_skip_relocation
    sha256 "d0219cfa8bd6cc6d92b35b8fa0cab880f0b93bf08fb1bc73c7f0181893f0fc21" => :sierra
    sha256 "71a0106395863005e9a00897db143d494017e691a2db7b47ed43c8a46bf3bbd5" => :el_capitan
    sha256 "664937870a0cbd75a0cbbfd7b1d24d9d8f3284fa9ace3968105d5f62910ab359" => :yosemite
    sha256 "966d0dfe96517d50de02c8c8c2d603084c105dc3ae837fe43e61c8481d42b3f8" => :mavericks
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
