class Gosu < Formula
  desc "Pragmatic language for the JVM"
  homepage "https://gosu-lang.github.io/"
  url "https://github.com/gosu-lang/gosu-lang/archive/v1.14.18.tar.gz"
  sha256 "b6bf6967ee127b727b4be56aaa02bc807340d4663e00dafd9fd8a6c1a5cd6958"
  license "Apache-2.0"
  head "https://github.com/gosu-lang/gosu-lang.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "f727564002df8588a711228ee9da4ff92636f32cbaac3f851d4840e9c6330649" => :catalina
    sha256 "ecd68c00bfcd4384bfb10d8ef05edb7e63b3835405514233dff3899766db4dff" => :mojave
    sha256 "45f6fc1936fc923213326882d70aaec798e0c1cffb7b33d05f9d6f1cc0e75b6c" => :high_sierra
  end

  depends_on "maven" => :build
  depends_on java: "1.8"

  skip_clean "libexec/ext"

  def install
    cmd = Language::Java.java_home_cmd("1.8")
    ENV["JAVA_HOME"] = Utils.safe_popen_read(cmd).chomp

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
