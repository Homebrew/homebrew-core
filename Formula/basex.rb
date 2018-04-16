class Basex < Formula
  desc "Light-weight XML database and XPath/XQuery processor"
  homepage "http://basex.org"
  url "http://files.basex.org/releases/9.0/BaseX90.zip"
  version "9.0"
  sha256 "46be7a12233672feb07d1d5c1c473868ce3e6dfe187a14e81279e6fcc530aba4"

  devel do
    url "http://files.basex.org/releases/latest/BaseX901-20180416.102831.zip"
    version "9.0.1-rc20180416.102831"
    sha256 "d1dee6212c6aae6d8e20f994f650bf5744487abb7de1a0bf4ef87b7996cf0722"
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
