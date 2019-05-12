class Gosu < Formula
  desc "Pragmatic language for the JVM"
  homepage "https://gosu-lang.github.io/"
  url "https://github.com/gosu-lang/gosu-lang/archive/v1.14.14.tar.gz"
  sha256 "11fd63daa7e00535c45ac075cad76d9414198022370ac9ab56553fb5a11facb3"
  head "https://github.com/gosu-lang/gosu-lang.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "bdca5f4a41a7bdefa1c992381c5c5c0de423399f4bf22a48c68ee362ac3bd350" => :mojave
    sha256 "28a49bc7c0c8283f90350c2f15f9200f3e70c46c2d87657613626b1efe2a095b" => :high_sierra
    sha256 "79865c6a13468549c36092e10e45938ac1d8567addfffe42f7d0f16beedca07e" => :sierra
  end

  depends_on "maven" => :build
  depends_on :java => "1.8"

  skip_clean "libexec/ext"

  def install
    cmd = Language::Java.java_home_cmd("1.8")
    ENV["JAVA_HOME"] = Utils.popen_read(cmd).chomp

    system "mvn", "package"
    libexec.install Dir["gosu/target/gosu-#{version}-full/gosu-#{version}/*"]
    (libexec/"ext").mkpath
    (bin/"gosu").write_env_script libexec/"bin/gosu", Language::Java.java_home_env("1.8")
  end

  test do
    (testpath/"test.gsp").write 'print ("burp")'
    assert_equal "burp", shell_output("#{bin}/gosu test.gsp").chomp
  end
end
