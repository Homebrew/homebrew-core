class Gosu < Formula
  desc "Pragmatic language for the JVM"
  homepage "http://gosu-lang.org/"
  url "https://github.com/gosu-lang/gosu-lang/archive/v1.14.10.tar.gz"
  sha256 "91adf2ba51231fd67ad4300316229c8eb75cbad249259cc32cbda13e01ae310e"
  head "https://github.com/gosu-lang/gosu-lang.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "fa07776764aae075fe40b7fff041cdf2102f12ecf915f18d4e4331f4e67e4094" => :high_sierra
    sha256 "cf97bd3669d2960b8017f15858660169ea8c339152e4d46fefa211fdfa6c685e" => :sierra
    sha256 "d0ffb9d7696f493ffe514199c57ddefba7d14e1cec2dc8065f371d3fb60ed17a" => :el_capitan
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
