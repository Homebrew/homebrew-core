class Groovy < Formula
  desc "Java-based scripting language"
  homepage "http://www.groovy-lang.org"
  url "https://dl.bintray.com/groovy/maven/apache-groovy-binary-2.5.3.zip"
  sha256 "47942bdb31a9f7ebf0db5b324bc99a289fd6ff87723e21e06f4701fa7c8c85c7"

  bottle :unneeded

  option "with-invokedynamic", "Install the InvokeDynamic version of Groovy (only works with Java 1.7+)"

  deprecated_option "invokedynamic" => "with-invokedynamic"

  depends_on :java => "1.6+"

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
