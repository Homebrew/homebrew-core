class Gosu < Formula
  desc "Pragmatic language for the JVM"
  homepage "http://gosu-lang.org/"
  url "https://github.com/gosu-lang/gosu-lang/archive/v1.14.11.tar.gz"
  sha256 "78b307b67a77941c065f171f473d7395a9b9f9b777ceb6f0c7434875b162e55d"
  head "https://github.com/gosu-lang/gosu-lang.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "1084dd28beda4453f255abca80ec9b8bc79f168b3a5a4cd3d3623e5c68e6fa5c" => :high_sierra
    sha256 "1ca6df5384e8c35339096b55c398f7201e4a0e8b53d959ea1e431c6af0b2fd06" => :sierra
    sha256 "ee811bdaa15babb338a88e9625750113c94abfe8f3c0b07e6da0080d1ef55b72" => :el_capitan
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
