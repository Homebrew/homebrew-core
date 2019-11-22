class Gosu < Formula
  desc "Pragmatic language for the JVM"
  homepage "https://gosu-lang.github.io/"
  url "https://github.com/gosu-lang/gosu-lang/archive/v1.14.15.tar.gz"
  sha256 "a1189f44713823ae189500630c5ecfccaee3931617544243f4da5400edb8dde5"
  head "https://github.com/gosu-lang/gosu-lang.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "0ea77190343c4ca60f3e07485e6bf53c508d154da74e59513ab3c47f809de6d2" => :catalina
    sha256 "b19609d890ddbf73a957475fd75f95e6cb7aa44d3ed9926a9a98be871f805687" => :mojave
    sha256 "f8dd37026105b216b0252fb4118c3761576f55379a31f6ddb985b06d33d46d73" => :high_sierra
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
