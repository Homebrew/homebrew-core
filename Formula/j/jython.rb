class Jython < Formula
  desc "Python implementation written in Java (successor to JPython)"
  homepage "https://www.jython.org/"
  url "https://search.maven.org/remotecontent?filepath=org/python/jython-installer/2.7.4/jython-installer-2.7.4.jar"
  sha256 "6001f0741ed5f4a474e5c5861bcccf38dc65819e25d46a258cbc0278394a070b"
  license "PSF-2.0"

  livecheck do
    url "https://search.maven.org/remotecontent?filepath=org/python/jython-installer/"
    regex(%r{href=["']?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "7c529b39cca604a3c60c7aaf3582f95f2c34dda67db1ff5ec50e6b276635f520"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "13e057d004350aeb89d008269280f5342064efc7cb4e66779bbb7661097a4492"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5f4cdcbf4f97999a663ea4251aa810cf84835e70da8a50c4bb4b0fc378a476b9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4d0f3bf41ef89c336e81c06e08d2aff10a9e9917459b0a4a7a5e1dd1f6f5a9c6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1c85fbc0ccfa9e3ba0b11fc2996716ed2da5578d6b385b921a50100882604d33"
    sha256 cellar: :any_skip_relocation, sonoma:         "fd1fb28373af09ab635cf1ba9a4531bdfd0ca61f777c880844daa8d6df426673"
    sha256 cellar: :any_skip_relocation, ventura:        "c24c368c2bdd03928c74e6807c2954343c05d72ea0bde7d048add87354d49d12"
    sha256 cellar: :any_skip_relocation, monterey:       "48be7bdcbcd3be1e5733a1181eb4f1a02f75d7d3a442a7a52e0aef7b7a29fb4f"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "64f495d1221b38c43ba23f2855c15d7953774602701abc80d843254b2e9646d6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ace9b3d90e73ef28c68731acdb4ace7ff14889380da8c07c0b3ddb425e8d43b0"
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
