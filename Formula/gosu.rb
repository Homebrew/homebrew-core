class Gosu < Formula
  desc "Pragmatic language for the JVM"
  homepage "http://gosu-lang.org/"
  url "https://github.com/gosu-lang/gosu-lang/archive/v1.14.8.tar.gz"
  sha256 "c0443f683f1add9712c2a095d78b239fad8f362baf91c33077e0358c07bcf5a1"
  head "https://github.com/gosu-lang/gosu-lang.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "c805706c6d1a3f97241eb8efb7de6e1790e2d46838188093df0d9effc080aad6" => :high_sierra
    sha256 "7236ef924d63609b9cddfdd53574aaeed285f83e6eac41d0664cc33f96b9bfab" => :sierra
    sha256 "929b3bca114c3c89acdd103fffbab1ae03b9b776bf4f1a616056644ee1364825" => :el_capitan
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
