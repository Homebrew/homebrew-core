class Gosu < Formula
  desc "Pragmatic language for the JVM"
  homepage "https://gosu-lang.github.io/"
  url "https://github.com/gosu-lang/gosu-lang/archive/v1.14.18.tar.gz"
  sha256 "b6bf6967ee127b727b4be56aaa02bc807340d4663e00dafd9fd8a6c1a5cd6958"
  license "Apache-2.0"
  head "https://github.com/gosu-lang/gosu-lang.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "346ffaff003137a940e06ea22ee79c166243810cafecd1f752a4a3e3093ba41a" => :catalina
    sha256 "6877e134bb30b420bfeed8d263ee592b38709b161d24417e1b65a3748afa650b" => :mojave
    sha256 "7ca50446a52ffe2a64d28719e274cb2e5515b4812f6e4b3082af38039eb75c75" => :high_sierra
  end

  depends_on "maven" => :build
  depends_on java: "1.8"

  skip_clean "libexec/ext"

  def install
    ENV["JAVA_HOME"] = Language::Java.java_home("1.8")

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
