class Jython < Formula
  desc "Python implementation written in Java (successor to JPython)"
  homepage "https://www.jython.org/"
  url "https://search.maven.org/remotecontent?filepath=org/python/jython-installer/2.7.2/jython-installer-2.7.2.jar"
  sha256 "36e40609567ce020a1de0aaffe45e0b68571c278c14116f52e58cc652fb71552"
  license "PSF-2.0"

  livecheck do
    url "https://github.com/jythontools/jython.git"
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  # This isn't accidental; there is actually a compile process here.
  bottle do
    cellar :any_skip_relocation
    sha256 "ecac33d533e405e4bd45cdf7023cd334fa655e17446cbfa5231dbf1e580166c5" => :catalina
    sha256 "3bd7cbb55035525c113c7608b9e18215b1a214c0f21e45203c900029765ba09f" => :mojave
    sha256 "644da593101c796e9b39e10ad7cd65f96e8e0d9ccf19109c8337a1f262ef005a" => :high_sierra
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
