class Jcliff < Formula
  desc "Manage JBossAS 7/EAP6/Wildfly with modular configuration files"
  homepage "https://github.com/bserdar/jcliff"
  url "https://github.com/bserdar/jcliff/releases/download/v2.12.1/jcliff-2.12.1-dist.tar.gz"
  sha256 "fb31e7b6227ebe0a5d782588fd9f47de814831896762a118dffb674993dabbc4"

  bottle :unneeded

  depends_on :java

  def install
    libexec.install Dir["rules", "*.jar"]

    (libexec/"bin").install "jcliff"
    (bin/"jcliff").write_env_script("#{libexec}/bin/jcliff", :JCLIFF_HOME => libexec.to_s)
  end

  def caveats
    <<~EOS
      Jcliff installed! Before use, the JBOSS_HOME environment variable must be set, similar to the following:
        export JBOSS_HOME=<Location of JBoss Server>
    EOS
  end

  test do
    ENV["JBOSS_HOME"] = opt_libexec
    assert_match "Jcliff version #{version}", shell_output("#{bin}/jcliff -v").chomp
  end
end
