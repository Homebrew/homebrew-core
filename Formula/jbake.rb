class Jbake < Formula
  desc "Java based static site/blog generator"
  homepage "https://jbake.org/"
  url "https://github.com/jbake-org/jbake/releases/download/v2.6.7/jbake-2.6.7-bin.zip"
  sha256 "8d9c2b70fbf26415c5b3e530088b8b7fd1d236d3ce2c98a9c03fff4734bced39"
  license "MIT"

  depends_on "openjdk"

  def install
    rm_f Dir["bin/*.bat"]
    libexec.install Dir["*"]
    bin.install libexec/"bin/jbake"
    bin.env_script_all_files libexec/"bin", JAVA_HOME: Formula["openjdk"].opt_prefix
  end

  test do
    assert_match "Usage: jbake", shell_output("#{bin}/jbake")
  end
end
