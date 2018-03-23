class Basex < Formula
  desc "Light-weight XML database and XPath/XQuery processor"
  homepage "http://basex.org"
  url "http://files.basex.org/releases/9.0/BaseX90.zip"
  version "9.0"
  sha256 "46be7a12233672feb07d1d5c1c473868ce3e6dfe187a14e81279e6fcc530aba4"

  devel do
    url "http://files.basex.org/releases/latest/BaseX901-20180323.194007.zip"
    version "9.0.1-rc20180323.194007"
    sha256 "3c6f17675884887047cc143357c3bb1e90a21780c186fd6b563a6cad00b1a9d3"
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
