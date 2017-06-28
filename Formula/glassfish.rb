class Glassfish < Formula
  desc "Java EE application server"
  homepage "https://glassfish.java.net"
  url "http://download.java.net/glassfish/4.1.2/release/glassfish-4.1.2.zip"
  sha256 "68d5c0d95152a07e68e9b00535b11e7b8727646eb8bca05f918abdadebac7266"

  bottle :unneeded

  def install
    rm_rf Dir["bin/*.bat"]
    libexec.install Dir["*", ".org.opensolaris,pkg"]
  end

  def caveats; <<-EOS.undent
    The home of GlassFish Application Server 4 is:
      #{opt_libexec}

    You may want to add the following to your .bash_profile:
      export GLASSFISH_HOME=#{opt_libexec}
      export PATH=${PATH}:${GLASSFISH_HOME}/bin

    Note: The support scripts used by GlassFish Application Server 4
    are *NOT* linked to bin.
  EOS
  end
end
