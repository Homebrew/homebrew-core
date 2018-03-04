class Jbake < Formula
  desc "Java based static site/blog generator"
  homepage "http://jbake.org"
  url "https://dl.bintray.com/jbake/binary/:jbake-2.6.0-bin.zip"
  sha256 "16ccf81446cea492e0919f9d19c2a93b55d35207bff27e938f3a9d1cc937fef8"

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
