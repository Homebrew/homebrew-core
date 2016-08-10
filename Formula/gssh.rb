class Gssh < Formula
  desc "SSH automation tool based on Groovy DSL"
  homepage "https://github.com/int128/groovy-ssh"
  url "https://github.com/int128/groovy-ssh/releases/download/2.4.3/gssh.jar"
  sha256 "4de86e0e8ddd1c127f5970e33bee667c03a28c82750264dc697bf7c1b4d8fcce"
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
