class Jython < Formula
  desc "Python implementation written in Java (successor to JPython)"
  homepage "https://www.jython.org/"
  url "https://search.maven.org/remotecontent?filepath=org/python/jython-installer/2.7.3/jython-installer-2.7.3.jar"
  sha256 "3ffc25c5257d2028b176912a4091fe048c45c7d98218e52d7ce3160a62fdc9fc"
  license "PSF-2.0"

  livecheck do
    url "https://search.maven.org/remotecontent?filepath=org/python/jython-installer/"
    regex(%r{href=["']?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "eafebcb36c11b6406b8c314e932317482257acabee5594d3c50eb874201dd8a8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "68df644ec1a6d98aa9fa16a928d935d9a0a5b22f4d5b0dfaa19c9352ae3f35c7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d118994b7fb4b6353adf4bd24fcd64556a06755c8f5409995cb11a225b950798"
    sha256 cellar: :any_skip_relocation, ventura:        "e3b34345a333541f41a7fad39d180764c39767506c8c30de05ee034301a9d165"
    sha256 cellar: :any_skip_relocation, monterey:       "0e4b255160c9cf926c8d0960ad4c304fed55479e07b3182749eb11dd90d74051"
    sha256 cellar: :any_skip_relocation, big_sur:        "9fea67ce3f805db15d3dc5e263efb3bc949d1ab3c474533ee15a5207686aeb27"
    sha256 cellar: :any_skip_relocation, catalina:       "b1a7f234b54746d1127bf17ec5a95122ef0d942b2ca97fef87bc32d0e71bcc91"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f9964506ee25d6ef2336c9d27e443f463a48d59df07f550070833bd29b91ea78"
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
