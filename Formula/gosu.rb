class Gosu < Formula
  desc "Pragmatic language for the JVM"
  homepage "http://gosu-lang.org/"
  url "https://github.com/gosu-lang/gosu-lang/archive/v1.14.7.tar.gz"
  sha256 "e6ff2895c027248dac172db28109159509535563bf3f077d1ec793841d0de208"
  head "https://github.com/gosu-lang/gosu-lang.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "2e6f9521f08a8f671c87a3b00330903ff0341bdf9041602a06a0d87b1174937d" => :high_sierra
    sha256 "f2940c8a91de1a513c50bf8b43a44c9dd37d6a7f80d7b9df4e9fcbdfd2c06b2e" => :sierra
    sha256 "8a1114631a42f36ed4727fd0eccc6038bb46187a5bc71f3a6a8ae7d284c61969" => :el_capitan
  end

  depends_on :java => "1.8"
  depends_on "maven" => :build

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
