class Gosu < Formula
  desc "Pragmatic language for the JVM"
  homepage "https://gosu-lang.github.io/"
  url "https://github.com/gosu-lang/gosu-lang/archive/v1.14.15.tar.gz"
  sha256 "a1189f44713823ae189500630c5ecfccaee3931617544243f4da5400edb8dde5"
  head "https://github.com/gosu-lang/gosu-lang.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "5050a4ef5819e867ef2622bce1feb80c35298e2902919c05637da510920c3936" => :mojave
    sha256 "68b43c58b7ef52e59d752c8adc945b9702040b4b516ac6797d1b55a199724084" => :high_sierra
    sha256 "8500d4aa760f6a63f135125fe1a05240ca993747c2274d2cc40df7be5e5af9c6" => :sierra
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
