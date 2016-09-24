class Groovysdk < Formula
  desc "SDK for Groovy: a Java-based scripting language"
  homepage "http://www.groovy-lang.org"
  url "https://dl.bintray.com/groovy/maven/apache-groovy-sdk-2.4.7.zip"
  sha256 "9a20d8868edbbc82a8edd03b6ae6f7dfbe406e42a468f2c44d5285493f679676"

  bottle :unneeded

  conflicts_with "groovy", :because => "both install the same binaries"

  def install
    ENV["GROOVY_HOME"] = libexec

    # We don't need Windows' files.
    rm_f Dir["bin/*.bat"]

    prefix.install_metafiles
    bin.install Dir["bin/*"]
    libexec.install %w[conf lib embeddable src doc]
    bin.env_script_all_files(libexec+"bin", :GROOVY_HOME => ENV["GROOVY_HOME"])
  end

  test do
    system "#{bin}/grape", "install", "org.activiti", "activiti-engine", "5.16.4"
  end
end
