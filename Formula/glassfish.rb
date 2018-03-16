class Glassfish < Formula
  desc "Java EE application server"
  homepage "https://glassfish.java.net/"
  url "https://download.oracle.com/glassfish/5.0/release/glassfish-5.0.zip"
  sha256 "85450f0cd4875729d64be6bcbf7ed8f61009ea0f23d3be453c6f3d1dbab02420"

  bottle :unneeded

  depends_on :java => "1.8+"

  conflicts_with "payara", :because => "both install the same scripts"

  def install
    rm_rf Dir["bin/*.bat"]
    libexec.install Dir["*", ".org.opensolaris,pkg"]
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  def caveats; <<~EOS
    You may want to add the following to your .bash_profile:
      export GLASSFISH_HOME=#{opt_libexec}
  EOS
  end
end
