class Grails < Formula
  desc "Web application framework for the Groovy language"
  homepage "https://grails.org"
  url "https://github.com/grails/grails-core/releases/download/v3.3.7/grails-3.3.7.zip"
  sha256 "1d4bd4127fbfdc9c07465b85deecfec5c746fb97468df891823e5063909d764f"

  bottle :unneeded

  def install
    rm_f Dir["bin/*.bat", "bin/cygrails", "*.bat"]
    libexec.install Dir["*"]
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  def caveats; <<~EOS
    The GRAILS_HOME directory is:
      #{opt_libexec}
  EOS
  end

  test do
    assert_match "Grails Version: #{version}", shell_output("#{bin}/grails -v")
  end
end
