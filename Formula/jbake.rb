class Jbake < Formula
  desc "Java based static site/blog generator"
  homepage "http://jbake.org"
  url "http://jbake.org/files/jbake-2.5.1-bin.zip"
  sha256 "4d3e1fa926b1beab38f4e073cac067e359ac9aef5b74580a2821f58209f286e4"

  bottle :unneeded

  def install
    rm_f Dir["bin/*.bat"]
    libexec.install Dir["*"]
    bin.write_jar_script "#{libexec}/jbake-core.jar", "jbake"
  end

  test do
    assert_match "Usage: jbake", shell_output("#{bin}/jbake")
  end
end
