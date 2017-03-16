class Grails < Formula
  desc "Web application framework for the Groovy language"
  homepage "https://grails.org"
  url "https://github.com/grails/grails-core/releases/download/v3.2.7/grails-3.2.7.zip"
  sha256 "781f19ab03578c5b045f40b0a37a225c9ab82445fad8e08f5e304789311cb5b3"

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
