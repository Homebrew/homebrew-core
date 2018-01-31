class Basex < Formula
  desc "Light-weight XML database and XPath/XQuery processor"
  homepage "http://basex.org"
  url "http://files.basex.org/releases/8.6.7/BaseX867.zip"
  version "8.6.7"
  sha256 "60faecf417f1607780a70a237138a2f839f2218d2d7bee20fa30b7738245a244"

  devel do
    url "http://files.basex.org/releases/latest/BaseX90-20180130.105237.zip"
    version "9.0-rc20180130.105237"
    sha256 "85d598a7e5d8ac5ba1fed175266493358b3fbdbead555c968e0b64ecb86a04f3"
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
