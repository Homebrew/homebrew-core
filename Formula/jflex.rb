class Jflex < Formula
  desc "Lexical analyzer generator for Java, written in Java"
  homepage "https://jflex.de/"
  url "https://jflex.de/release/jflex-1.8.2.tar.gz"
  sha256 "a1e0d25e341d01de6b93ec32b45562905e69d06598113934b74f76b1be7927ab"
  revision 1

  bottle :unneeded

  depends_on "openjdk"

  def install
    pkgshare.install "examples"
    libexec.install "lib/jflex-full-#{version}.jar" => "jflex-#{version}.jar"
    bin.write_jar_script libexec/"jflex-#{version}.jar", "jflex"
  end

  test do
    system bin/"jflex", "-d", testpath, pkgshare/"examples/cup-java/src/main/jflex/java.flex"
    assert_match /public static void/, (testpath/"Scanner.java").read
  end
end
