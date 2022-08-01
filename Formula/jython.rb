class Jython < Formula
  desc "Python implementation written in Java (successor to JPython)"
  homepage "https://www.jython.org/"
  url "https://search.maven.org/remotecontent?filepath=org/python/jython-installer/2.7.2/jython-installer-2.7.2.jar"
  sha256 "36e40609567ce020a1de0aaffe45e0b68571c278c14116f52e58cc652fb71552"
  license "PSF-2.0"
  revision 2

  livecheck do
    url "https://search.maven.org/remotecontent?filepath=org/python/jython-installer/"
    regex(%r{href=["']?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "148beb4c1aa67c6c390dd5530d4da0d062e152045c8f64d1b49ac4aab05ac7b1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "673cc21a8fd119ee9993a3645b14c64eba223686fae50c8f5f0bed16c542a073"
    sha256 cellar: :any_skip_relocation, monterey:       "e08ba6665706dc4664e9dbec1429fbad583aefefaa187612395a153f966efdca"
    sha256 cellar: :any_skip_relocation, big_sur:        "bdc04dd4b13b61622e073dfa28ac9aea21e341c8f062574fb05885e9bfd7ec0b"
    sha256 cellar: :any_skip_relocation, catalina:       "614256bdfaf1dcaed3e4716002417966ab351f1edfc1421c9a7164af6cb81830"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f44ec6eb8585636d06fe1dc297033e8a8d40f522442d8fb5b466d4442319c867"
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
