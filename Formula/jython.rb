class Jython < Formula
  desc "Python implementation written in Java (successor to JPython)"
  homepage "http://www.jython.org"
  url "https://search.maven.org/remotecontent?filepath=org/python/jython-installer/2.7.1/jython-installer-2.7.1.jar"
  sha256 "6e58dad0b8565b95c6fb14b4bfbf570523d1c5290244cfb33822789fa53b1d25"

  # This isn't accidental; there is actually a compile process here.
  bottle do
    sha256 "495bcaf3acffdb941e3ee2080252f878a3e853229ab9a491475a9fdb773cf05f" => :mojave
    sha256 "71b9c25bb4ef023ad684f4c1f062eafe678d388a11cf20ce1a1e69732ef557f5" => :high_sierra
    sha256 "98bd9e1dcd92f8a0e281db6430985a2b67b2db36143d04a286502128fa9598af" => :sierra
    sha256 "865533fa4016f5d378badbd0fce6e9bad6b373a65b6feab152a27dffdd12603b" => :el_capitan
    sha256 "39b916844c6df58ca9e20f8125df6d4166fbcb18d732069a92a5b71edab13093" => :yosemite
  end

  def install
    system "java", "-jar", cached_download, "-s", "-d", libexec
    bin.install_symlink libexec/"bin/jython"
  end

  test do
    jython = shell_output("#{bin}/jython -c \"from java.util import Date; print Date()\"")
    # This will break in the year 2100. The test will need updating then.
    assert_match jython.match(/20\d\d/).to_s, shell_output("/bin/date +%Y")
  end
end
