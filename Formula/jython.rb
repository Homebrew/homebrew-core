class Jython < Formula
  desc "Python implementation written in Java (successor to JPython)"
  homepage "https://www.jython.org/"
  url "https://search.maven.org/remotecontent?filepath=org/python/jython-installer/2.7.2/jython-installer-2.7.2.jar"
  sha256 "36e40609567ce020a1de0aaffe45e0b68571c278c14116f52e58cc652fb71552"
  license "PSF-2.0"
  revision 1

  livecheck do
    url "https://search.maven.org/remotecontent?filepath=org/python/jython-installer/"
    regex(%r{href=["']?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "df7449a61b5503533837daa4e6b482433846bcd7711fb6a217ffe3186c359870"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "df7449a61b5503533837daa4e6b482433846bcd7711fb6a217ffe3186c359870"
    sha256 cellar: :any_skip_relocation, monterey:       "839d5567f080b613bfd533136098e600f6364b371aad688dd2427dd33a7eea1f"
    sha256 cellar: :any_skip_relocation, big_sur:        "774e319da7e0c604ac7c6bd894aee3e4bebe83a94d0c87ec847e63ba3f4dca33"
    sha256 cellar: :any_skip_relocation, catalina:       "01daf9373cdf4140ff89acb5dd8b6a3537eae8cc6a9d3200cc8dddff83ce9e0e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a2a44cf702b9351f1687ada2ac71f552e641d3230fe39fccd30a101c40946f7f"
  end

  depends_on "openjdk"

  def install
    system "java", "-jar", cached_download, "-s", "-d", libexec
    (bin/"jython").write_env_script libexec/"bin/jython", Language::Java.overridable_java_home_env
  end

  test do
    jython = shell_output("#{bin}/jython -c \"from java.util import Date; print Date()\"")
    # This will break in the year 2100. The test will need updating then.
    assert_match jython.match(/20\d\d/).to_s, shell_output("/bin/date +%Y")
  end
end
