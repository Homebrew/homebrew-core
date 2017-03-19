class JbossAsAT5 < Formula
  desc "JBoss Application Server"
  homepage "https://www.jboss.org/jbossas"
  url "https://downloads.sf.net/project/jboss/JBoss/JBoss-5.1.0.GA/jboss-5.1.0.GA.zip"
  version "5.1.0GA"
  sha256 "be93bcb8f1ff03d7e64c98f2160a2415602268d84f44fb78cddb26303a8cbd3f"

  def install
    rm_f Dir["bin/*.bat"]
    libexec.install Dir["*"]
  end

  def caveats; <<-EOS.undent
      The home of JBoss Application Server 5 is:
      #{libexec}

      You may want to add the following to your .bash_profile:
        export JBOSS_HOME=#{libexec}
        export PATH=${PATH}:${JBOSS_HOME}/bin

      Note: The support scripts used by JBoss Application Server 5 have
      very generic names. These are likely to conflict with support scripts
      used by other Java-based server software. Hence they are *NOT* linked
      to bin.
    EOS
  end
end
