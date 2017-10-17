class Glassfish < Formula
  desc "Java EE application server"
  homepage "https://glassfish.java.net"
  url "https://github.com/javaee/glassfish/archive/5.0.tar.gz"
  sha256 "24f56e303f4b528997dbd532130b4818d88c4ef545f2d81b7c070fa67e279474"

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
