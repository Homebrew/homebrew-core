class Basex < Formula
  desc "Light-weight XML database and XPath/XQuery processor"
  homepage "http://basex.org"
  url "http://files.basex.org/releases/8.6.7/BaseX867.zip"
  version "8.6.7"
  sha256 "60faecf417f1607780a70a237138a2f839f2218d2d7bee20fa30b7738245a244"

  devel do
    url "http://files.basex.org/releases/latest/BaseX90-20180220.145902.zip"
    version "9.0-rc20180220.145902"
    sha256 "c7bb2737997cc4afa8e95d87702a51e65c562a410c264125b1b5aaa9bca6e5b0"
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
