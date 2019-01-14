class Grails < Formula
  desc "Web application framework for the Groovy language"
  homepage "https://grails.org"
  url "https://github.com/grails/grails-core/releases/download/v3.3.9/grails-3.3.9.zip"
  sha256 "d6c214642dadbb450db306a17fc6ff3a60fd9d1f515cc91b273f239a6a8adc76"

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
