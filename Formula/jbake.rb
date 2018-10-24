class Jbake < Formula
  desc "Java based static site/blog generator"
  homepage "https://jbake.org/"
  url "https://dl.bintray.com/jbake/binary/jbake-2.6.3-bin.zip"
  sha256 "5109895cb26de9f856fab3038d621a33ddbd3cfa0292cad969dfcca3993d82d9"

  bottle :unneeded

  depends_on :java => "1.7+"

  def install
    rm_f Dir["bin/*.bat"]
    libexec.install Dir["*"]
    bin.install_symlink libexec/"bin/jbake"
  end

  test do
    assert_match "Usage: jbake", shell_output("#{bin}/jbake")
  end
end
