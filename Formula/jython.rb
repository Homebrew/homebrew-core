class Jython < Formula
  desc "Python implementation written in Java (successor to JPython)"
  homepage "https://www.jython.org/"
  url "https://search.maven.org/remotecontent?filepath=org/python/jython-installer/2.7.1/jython-installer-2.7.1.jar"
  sha256 "6e58dad0b8565b95c6fb14b4bfbf570523d1c5290244cfb33822789fa53b1d25"

  # This isn't accidental; there is actually a compile process here.
  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "fca25829eec71179473b89517038a63cbe6a0da68594b7b63846b0e9a8194b14" => :catalina
    sha256 "e64dc854f84ba16de19059102aa5c94d01b9ed2a996e3bafa7df1f6f2c19e3ca" => :mojave
    sha256 "0ff369744b44ef3e03dd405e6c479c93a43770778c4f5f6eaea25e98ca5c7edf" => :high_sierra
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
