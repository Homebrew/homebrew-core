class Gssh < Formula
  desc "SSH automation tool based on Groovy DSL"
  homepage "https://github.com/int128/groovy-ssh"
  url "https://github.com/int128/groovy-ssh/releases/download/2.4.0/gssh.jar"
  sha256 "4c93b948b4d036e6e8167cb6f784f53b413ec2a87de1317b726c5b8d4aeea733"

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
