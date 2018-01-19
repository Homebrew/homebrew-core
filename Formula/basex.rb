class Basex < Formula
  desc "Light-weight XML database and XPath/XQuery processor"
  homepage "http://basex.org"
  url "http://files.basex.org/releases/8.6.7/BaseX867.zip"
  version "8.6.7"
  sha256 "60faecf417f1607780a70a237138a2f839f2218d2d7bee20fa30b7738245a244"

  devel do
    url "http://files.basex.org/releases/latest/BaseX90-20180118.190229.zip"
    version "9.0-rc20180118.190229"
    sha256 "e4f4409848efb40411826267810d6932bbdbb361c13c4a101ca6b5e980da26c6"
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
