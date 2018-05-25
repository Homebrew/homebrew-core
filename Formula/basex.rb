class Basex < Formula
  desc "Light-weight XML database and XPath/XQuery processor"
  homepage "http://basex.org"
  url "http://files.basex.org/releases/9.0.1/BaseX901.zip"
  version "9.0.1"
  sha256 "6c51766ebe976e214cb1b3f3b8d7777d87c5cbef9134bcbf62da0278a47aa00b"

  devel do
    url "http://files.basex.org/releases/homebrew-snapshot/BaseX902-20180515.190444.zip"
    version "9.0.2-rc20180515.190444"
    sha256 "4603bdcd05ba550edb056c75e1e3c70253bbfc5f70d42afce8eeca4003ecf05d"
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
