class Gosu < Formula
  desc "Pragmatic language for the JVM"
  homepage "http://gosu-lang.org/"
  url "https://github.com/gosu-lang/gosu-lang/archive/v1.13.5.tar.gz"
  sha256 "5af5ee448640855dfa171fde8102fadf8941bd33112a72d17686243b40c9173d"
  head "https://github.com/gosu-lang/gosu-lang.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "84d7a65921c948ea32ce8b9f06bfba443c3795c6f0175f5da8e01aa62359ac5a" => :el_capitan
    sha256 "a86aba3082810c1c34dcf79496c5e90147fb9fea73bcb2fedb76182522353cc4" => :yosemite
    sha256 "dfac4f0a43a9e2c1c3701c79701cbd2287dcc160b09e8b258a46a3530db98032" => :mavericks
  end

  depends_on :java => "1.8+"
  depends_on "maven" => :build

  skip_clean "libexec/ext"

  def install
    ENV.java_cache

    system "mvn", "package"
    libexec.install Dir["gosu/target/gosu-#{version}-full/gosu-#{version}/*"]
    (libexec/"ext").mkpath
    bin.install_symlink libexec/"bin/gosu"
  end

  test do
    (testpath/"test.gsp").write 'print ("burp")'
    assert_equal "burp", shell_output("#{bin}/gosu test.gsp").chomp
  end
end
