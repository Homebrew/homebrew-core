class Jython < Formula
  desc "Python implementation written in Java (successor to JPython)"
  homepage "https://www.jython.org/"
  url "https://search.maven.org/remotecontent?filepath=org/python/jython-installer/2.7.2/jython-installer-2.7.2.jar"
  sha256 "36e40609567ce020a1de0aaffe45e0b68571c278c14116f52e58cc652fb71552"
  license "PSF-2.0"

  livecheck do
    url "https://search.maven.org/remotecontent?filepath=org/python/jython-installer/"
    regex(%r{href=["']?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  # This isn't accidental; there is actually a compile process here.
  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6f573f01ccb166b2988aef09b26f6a4a6e88bd8919c138fde090fad93698d053"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6f573f01ccb166b2988aef09b26f6a4a6e88bd8919c138fde090fad93698d053"
    sha256 cellar: :any_skip_relocation, monterey:       "72783566b912198b75aad24a009b77e1c70f61888aac0735012b4cf1541d3741"
    sha256 cellar: :any_skip_relocation, big_sur:        "b6d2e1a6bc8a60010eb0357f7ca775160930005f2270f511f867b4341aa47a40"
    sha256 cellar: :any_skip_relocation, catalina:       "ecac33d533e405e4bd45cdf7023cd334fa655e17446cbfa5231dbf1e580166c5"
    sha256 cellar: :any_skip_relocation, mojave:         "3bd7cbb55035525c113c7608b9e18215b1a214c0f21e45203c900029765ba09f"
    sha256 cellar: :any_skip_relocation, high_sierra:    "644da593101c796e9b39e10ad7cd65f96e8e0d9ccf19109c8337a1f262ef005a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4d646b100ffc6a75064902f9db2918cad5471df3e0e352c37725198b55f0f09f"
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
