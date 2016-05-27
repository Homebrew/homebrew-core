class Grails < Formula
  desc "Web application framework for the Groovy language"
  homepage "https://grails.org"
  url "https://github.com/grails/grails-core/releases/download/v3.1.7/grails-3.1.7.zip"
  sha256 "7c6da3a0c5fc6f67845368c84af3c1af757934230d8d3888aed4fa8e39f4b31e"

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
