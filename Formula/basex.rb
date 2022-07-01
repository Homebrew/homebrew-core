class Basex < Formula
  desc "Light-weight XML database and XPath/XQuery processor"
  homepage "https://basex.org"
  url "https://files.basex.org/releases/9.7.3/BaseX973.zip"
  version "9.7.3"
  sha256 "ca6ba2b534283dd9b9646bba87c51662229b5101d4cf6afa07c5a62641df60e3"
  license "BSD-3-Clause"

  livecheck do
    url "https://files.basex.org/releases/"
    regex(%r{href=.*?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "c642512410ac393ee7392df6a4de1a7d8e1776b7835b80065b705968771b56a2"
  end

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
