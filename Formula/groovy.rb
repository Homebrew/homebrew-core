class Groovy < Formula
  desc "Java-based scripting language"
  homepage "https://www.groovy-lang.org/"
  url "https://dl.bintray.com/groovy/maven/apache-groovy-binary-3.0.7.zip"
  sha256 "b9e2041cb83a963922f6761a0b037c5784670616632142b8d7002b7c3a96b7f5"
  license "Apache-2.0"

  livecheck do
    url "https://dl.bintray.com/groovy/maven/"
    regex(/href=.*?groovy-binary[._-]v?([\d.]+)\.zip/i)
  end

  bottle :unneeded

  depends_on "openjdk"

  conflicts_with "groovysdk", because: "both install the same binaries"

  def install
    # Don't need Windows files.
    rm_f Dir["bin/*.bat"]

    libexec.install "bin", "conf", "lib"
    bin.install Dir["#{libexec}/bin/*"] - ["#{libexec}/bin/groovy.ico"]
    bin.env_script_all_files libexec/"bin", Language::Java.overridable_java_home_env
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
