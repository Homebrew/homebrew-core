class Gssh < Formula
  desc "SSH automation tool based on Groovy DSL"
  homepage "https://github.com/int128/groovy-ssh"
  url "https://github.com/int128/groovy-ssh/releases/download/2.7.0/gssh.jar"
  sha256 "32646321b01e42b40f339a9d7647ea4cadcf9a26f827944144f0baf99e85f00d"
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
