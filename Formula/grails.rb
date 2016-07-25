class Grails < Formula
  desc "Web application framework for the Groovy language"
  homepage "https://grails.org"
  url "https://github.com/grails/grails-core/releases/download/v3.1.9/grails-3.1.9.zip"
  sha256 "36589f2d1bf74ffadc5ec4f3956953234163a3b04376209a40d8f5f6d07ffa14"

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
    assert_match "Grails Version: #{version}", shell_output("#{bin}/grails -v")
  end
end
