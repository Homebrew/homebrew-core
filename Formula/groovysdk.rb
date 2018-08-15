class Groovysdk < Formula
  desc "SDK for Groovy: a Java-based scripting language"
  homepage "http://www.groovy-lang.org"
  url "https://dl.bintray.com/groovy/maven/apache-groovy-sdk-2.5.2.zip"
  sha256 "82cf4f424a431b0ebab97e7302cfbe7c0b15cd5d2ff87cb0d9af5003e2ea247b"

  bottle :unneeded

  depends_on :java => "1.6+"

  conflicts_with "groovy", :because => "both install the same binaries"

  def install
    ENV["GROOVY_HOME"] = libexec

    # We don't need Windows' files.
    rm_f Dir["bin/*.bat"]

    prefix.install_metafiles
    bin.install Dir["bin/*"]
    libexec.install "conf", "lib", "src", "doc"
    bin.env_script_all_files(libexec+"bin", :GROOVY_HOME => ENV["GROOVY_HOME"])
  end

  test do
    system "#{bin}/grape", "install", "org.activiti", "activiti-engine", "5.16.4"
  end
end
