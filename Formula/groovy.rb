class Groovy < Formula
  desc "Java-based scripting language"
  homepage "https://www.groovy-lang.org/"
  url "https://dl.bintray.com/groovy/maven/apache-groovy-binary-3.0.0.zip"
  sha256 "f4b2211e7651ed4ec7728c96c1e1961795c4a9de7b0cad6d399df8e92001d682"

  bottle :unneeded

  # Groovy 2.5 requires JDK8+ to build and JDK7 is the minimum version of the JRE that we support.
  depends_on :java => "1.7+"

  conflicts_with "groovysdk", :because => "both install the same binaries"

  def install
    # Don't need Windows files.
    rm_f Dir["bin/*.bat"]

    libexec.install "bin", "conf", "lib"
    bin.install_symlink Dir["#{libexec}/bin/*"] - ["#{libexec}/bin/groovy.ico"]
  end

  def caveats
    <<~EOS
      You should set GROOVY_HOME:
        export GROOVY_HOME=#{opt_libexec}
    EOS
  end

  test do
    system "#{bin}/grape", "install", "org.activiti", "activiti-engine", "5.16.4"
  end
end
