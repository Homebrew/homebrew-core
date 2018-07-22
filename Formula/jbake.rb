class Jbake < Formula
  desc "Java based static site/blog generator"
  homepage "https://jbake.org/"
  url "https://dl.bintray.com/jbake/binary/jbake-2.6.1-bin.zip"
  sha256 "2cb17bee2bed09e7e251f727ddf73b15cbed9c5e3bed277cf7b4d329c89bdf14"

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
