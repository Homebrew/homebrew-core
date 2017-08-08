class Glassfish < Formula
  desc "Java EE application server"
  homepage "https://glassfish.java.net"
  url "http://download.java.net/glassfish/4.1.2/release/glassfish-4.1.2.zip"
  sha256 "68d5c0d95152a07e68e9b00535b11e7b8727646eb8bca05f918abdadebac7266"
  revision 1

  bottle :unneeded

  depends_on :java => "1.7+"

  conflicts_with "payara", :because => "both install the same scripts"

  def install
    rm_rf Dir["bin/*.bat"]
    libexec.install Dir["*", ".org.opensolaris,pkg"]
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  def caveats; <<-EOS.undent
    You may want to add the following to your .bash_profile:
      export GLASSFISH_HOME=#{opt_libexec}
  EOS
  end
end
