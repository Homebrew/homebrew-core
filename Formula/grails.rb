class Grails < Formula
  desc "Web application framework for the Groovy language"
  homepage "https://grails.org"
  url "https://github.com/grails/grails-core/releases/download/v3.3.5/grails-3.3.5.zip"
  sha256 "b5840f3272b7bbec2c3b4c221b540e8d881ab463ff596d5ceb7b64bad892261d"

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
