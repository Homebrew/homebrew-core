class Jflex < Formula
  desc "Lexical analyzer generator for Java, written in Java"
  homepage "https://jflex.de/"
  url "https://github.com/jflex-de/jflex/releases/download/v1.9.1/jflex-1.9.1.tar.gz"
  sha256 "e0c1e9eef91ff6df04d73fa5eaff13f3a02b679fee1474e5ccae007224df6df6"
  license "BSD-3-Clause"

  livecheck do
    url "https://jflex.de/download.html"
    regex(/href=.*?jflex[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "af48c16f0b4ceca171b84c4d947c4e1689bbfd22a66d5d42eead8485b7dc21cf"
  end

  depends_on "openjdk"

  def install
    pkgshare.install "examples"
    libexec.install "lib/jflex-full-#{version}.jar" => "jflex-#{version}.jar"
    bin.write_jar_script libexec/"jflex-#{version}.jar", "jflex"
  end

  test do
    system bin/"jflex", "-d", testpath, pkgshare/"examples/cup-java/src/main/jflex/java.flex"
    assert_match "public static void", (testpath/"Scanner.java").read
  end
end
