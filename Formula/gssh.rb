class Gssh < Formula
  desc "SSH automation tool based on Groovy DSL"
  homepage "https://github.com/int128/groovy-ssh"
  url "https://github.com/int128/groovy-ssh/releases/download/2.5.1/gssh.jar"
  sha256 "e489ae99ffe3f14a35af6b65c3d63c113566d6a186397b0adf606494c8aab1fd"
  head "https://github.com/int128/groovy-ssh.git"

  bottle :unneeded

  depends_on :java => "1.6+"

  def install
    if build.head?
      system "./gradlew", "shadowJar"
      libexec.install "build/libs/gssh.jar"
    else
      libexec.install "gssh.jar"
    end
    bin.write_jar_script libexec/"gssh.jar", "gssh"
  end

  test do
    system bin/"gssh"
  end
end
