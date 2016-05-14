class Grails < Formula
  desc "Web application framework for the Groovy language"
  homepage "https://grails.org"
  url "https://github.com/grails/grails-core/releases/download/v3.1.6/grails-3.1.6.zip"
  sha256 "0705581ce8efe95bc10d46e168740b7b3704976543d7480b6e43e7999c9e00a7"

  bottle :unneeded

  def install
    rm_f Dir["bin/*.bat", "bin/cygrails", "*.bat"]
    libexec.install Dir["*"]
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  def caveats; <<-EOS.undent
    The GRAILS_HOME directory is:
      #{opt_libexec}
    EOS
  end

  test do
    output = shell_output("#{bin}/grails --version")
    assert_match /Grails Version: #{version}/, output
  end
end
