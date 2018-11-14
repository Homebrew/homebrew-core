class Groovy < Formula
  desc "Java-based scripting language"
  homepage "http://www.groovy-lang.org"
  url "https://dl.bintray.com/groovy/maven/apache-groovy-binary-2.5.4.zip"
  sha256 "b2c936069831861d89cb8cf771bfa8a739b1d03c4be01b62d94e453e4b0bc6e8"

  bottle :unneeded

  option "with-invokedynamic", "Install the InvokeDynamic version of Groovy"

  deprecated_option "invokedynamic" => "with-invokedynamic"

  # Groovy 2.5 requires JDK8+ to build and JDK7 is the minimum version of the JRE that we support.
  depends_on :java => "1.7+"

  conflicts_with "groovysdk", :because => "both install the same binaries"

  def install
    # Don't need Windows files.
    rm_f Dir["bin/*.bat"]

    if build.with? "invokedynamic"
      Dir.glob("indy/*.jar") do |src_path|
        dst_file = File.basename(src_path, "-indy.jar") + ".jar"
        dst_path = File.join("lib", dst_file)
        mv src_path, dst_path
      end
    end

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
