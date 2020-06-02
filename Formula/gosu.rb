class Gosu < Formula
  desc "Pragmatic language for the JVM"
  homepage "https://gosu-lang.github.io/"
  url "https://github.com/gosu-lang/gosu-lang/archive/v1.14.18.tar.gz"
  sha256 "b6bf6967ee127b727b4be56aaa02bc807340d4663e00dafd9fd8a6c1a5cd6958"
  head "https://github.com/gosu-lang/gosu-lang.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "05843747afc7f3bb95cf0ae0413d218dde1ecebbe4a3c7ac5c6d0831d0da6489" => :catalina
    sha256 "04dde03092618f8a2861c332645acbfc0ae03eb4c96ca1b448736bb0212ab3b2" => :mojave
    sha256 "eb952e54e288bdf091aef6cc31326ea2df89c29b4b9578a24dd922454318a810" => :high_sierra
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
