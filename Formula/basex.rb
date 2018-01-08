class Basex < Formula
  desc "Light-weight XML database and XPath/XQuery processor"
  homepage "http://basex.org"
  url "http://files.basex.org/releases/8.6.6/BaseX866.zip"
  version "8.6.6"
  sha256 "a41a6cc365741b8ee796ad22ce4acbe9f319059c5bca08fd094a351db9369acf"

  devel do
    url "http://files.basex.org/releases/latest/BaseX90-20171222.150150.zip"
    version "9.0-rc20171222.150150"
    sha256 "11d557e28ae3cfcb77895d4c5e105dd1028d914a125f7b11665c0d93f8637d5e"
  end

  bottle :unneeded

  depends_on :java => "1.7+"

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
