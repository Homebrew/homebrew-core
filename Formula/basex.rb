class Basex < Formula
  desc "Light-weight XML database and XPath/XQuery processor"
  homepage "https://basex.org"
  url "https://files.basex.org/releases/9.4.2/BaseX942.zip"
  version "9.4.2"
  sha256 "e58dfc425c88ab8f4d45c0c9ea64684a298205b5947c7586f40286c23fcf6976"
  license "BSD-3-Clause"

  livecheck do
    url "https://files.basex.org/releases/"
    regex(%r{href=.*?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle :unneeded

  depends_on "openjdk"

  def install
    rm Dir["bin/*.bat"]
    rm_rf "repo"
    rm_rf "data"
    rm_rf "etc"
    prefix.install_metafiles
    libexec.install Dir["*"]
    bin.install Dir["#{libexec}/bin/*"]
    bin.env_script_all_files libexec/"bin", JAVA_HOME: Formula["openjdk"].opt_prefix
  end

  test do
    assert_equal "1\n2\n3\n4\n5\n6\n7\n8\n9\n10", shell_output("#{bin}/basex '1 to 10'")
  end
end
