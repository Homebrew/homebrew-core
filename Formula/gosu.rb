class Gosu < Formula
  desc "Pragmatic language for the JVM"
  homepage "https://gosu-lang.github.io/"
  url "https://github.com/gosu-lang/gosu-lang/archive/v1.14.20.tar.gz"
  sha256 "56c4782087c20ed9a5d6e8912d128c3f87d6906d74c0b75d3b63d7fabd705e73"
  license "Apache-2.0"
  head "https://github.com/gosu-lang/gosu-lang.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "0947d7036e1ee41f8e69dea2a734c958bb43dc3dbff61fe9261f7e4d94757785" => :big_sur
    sha256 "d77da13db9da60d37cf3babc87f4d579ecc5753e26619c2bf56903edca129f0d" => :catalina
    sha256 "b41812388af2fdbfdf31c5c5254ab74d8771bdaf56ced7e75f5c07070d36e79d" => :mojave
    sha256 "88e6e992e4698091862b8f5cf2fb129686dcb76c6114a5dffd163ee97457e9d1" => :high_sierra
  end

  depends_on "maven" => :build
  depends_on "openjdk@8"

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
