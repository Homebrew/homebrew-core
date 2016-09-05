class Gssh < Formula
  desc "SSH automation tool based on Groovy DSL"
  homepage "https://github.com/int128/groovy-ssh"
  url "https://github.com/int128/groovy-ssh/releases/download/2.6.0/gssh.jar"
  sha256 "78aa1c587de772d6a2d4392899a91b088e91d1ffe3585d92510c693e7d0d18d6"
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
