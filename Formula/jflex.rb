class Jflex < Formula
  desc "Lexical analyzer generator for Java, written in Java"
  homepage "http://jflex.de/"
  url "http://jflex.de/release/jflex-1.7.0.zip"
  sha256 "833ea6371a4b5ee16023f328fbf7babd41a71e93155cf869c53f3ff670508107"

  bottle :unneeded

  depends_on :java => "1.7+"

  def install
    pkgshare.install "examples"
    libexec.install "lib/jflex-full-#{version}.jar" => "jflex-#{version}.jar"
    bin.write_jar_script libexec/"jflex-#{version}.jar", "jflex"
  end

  test do
    system bin/"jflex", "-d", testpath, pkgshare/"examples/java/java.flex"
    assert_match /public static void/, (testpath/"Scanner.java").read
  end
end
