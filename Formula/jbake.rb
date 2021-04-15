class Jbake < Formula
  desc "Java based static site/blog generator"
  homepage "https://jbake.org/"
  url "https://github.com/jbake-org/jbake/releases/download/v2.6.6/jbake-2.6.6-bin.zip"
  sha256 "4783f5bc33a3a5eb24f5557cd61c79128397271d8e145cd74be33547662e5274"
  license "MIT"

  bottle :unneeded

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
