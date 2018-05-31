class Gosu < Formula
  desc "Pragmatic language for the JVM"
  homepage "http://gosu-lang.org/"
  url "https://github.com/gosu-lang/gosu-lang/archive/v1.14.10.tar.gz"
  sha256 "91adf2ba51231fd67ad4300316229c8eb75cbad249259cc32cbda13e01ae310e"
  head "https://github.com/gosu-lang/gosu-lang.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "f5077478c1ba8a999be94aa756b5554929ed352d17fd3cdf622d2c5115d5316f" => :high_sierra
    sha256 "3e6f10634f9f42566d4b050e033d734906e42503bc8f08aa42040482e8ceecff" => :sierra
    sha256 "4a897e1b979975b4be97712de364fd99024a4783b987d220f853f192da99f47a" => :el_capitan
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
