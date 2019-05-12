class Glassfish < Formula
  desc "Open Source Jakarta EE Platform Implementation"
  homepage "https://eclipse-ee4j.github.io/glassfish/"
  url "https://www.eclipse.org/downloads/download.php?file=/glassfish/glassfish-5.1.0.zip&mirror_id=518"i
  sha256 "26f3fa6463d24c5ed3956e4cab24a97e834ca37d7a23d341aadaa78d9e0093ce"

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
