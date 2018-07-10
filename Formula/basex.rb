class Basex < Formula
  desc "Light-weight XML database and XPath/XQuery processor"
  homepage "http://basex.org"
  url "http://files.basex.org/releases/9.0.2/BaseX902.zip"
  version "9.0.2"
  sha256 "db2c4b5b0e0461f871f9960fc9b2f601b30efb775e67e830e3eab69bf2cae49d"

  devel do
    url "http://files.basex.org/releases/homebrew-snapshot/BaseX91-20180710.140237.zip"
    version "9.1-rc20180710.140237"
    sha256 "21b7ddc4904ededa3b91bbadf4df234b0793429289140a9d50f75a1484e185e8"
  end

  bottle :unneeded

  depends_on :java => "1.8+"

  def install
    rm Dir["bin/*.bat"]
    rm_rf "repo"
    rm_rf "data"
    rm_rf "etc"
    prefix.install_metafiles
    libexec.install Dir["*"]
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_equal "1\n2\n3\n4\n5\n6\n7\n8\n9\n10", shell_output("#{bin}/basex '1 to 10'")
  end
end
