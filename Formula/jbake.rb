class Jbake < Formula
  desc "Java based static site/blog generator"
  homepage "https://jbake.org/"
  url "https://dl.bintray.com/jbake/binary/jbake-2.6.4-bin.zip"
  sha256 "831149752f72005e3ebf6e7f554b0bf880a8df74faf4bfcf0ec746185316faf0"

  bottle :unneeded

  depends_on "openjdk"

  def install
    rm_f Dir["bin/*.bat"]
    libexec.install Dir["*"]
    bin.install libexec/"bin/jbake"
    bin.env_script_all_files libexec/"bin", :JAVA_HOME => Formula["openjdk"].opt_prefix
  end

  test do
    assert_match "Usage: jbake", shell_output("#{bin}/jbake")
  end
end
