class Htmlcleaner < Formula
  desc "HTML parser written in Java"
  homepage "https://htmlcleaner.sourceforge.io"
  url "https://downloads.sourceforge.net/project/htmlcleaner/htmlcleaner/htmlcleaner%20v2.24/htmlcleaner-2.24-src.zip"
  sha256 "ee476c1f31eabcbd56c174ec482910e1b19907ad3e57dff9a4d0a2f456c9cd42"
  license "BSD-3-Clause"
  revision 1

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "d32d3ccb0c576385b2fcbd5111f0e896097e2053be0a3abf4b76a2b5abbec890" => :catalina
    sha256 "7162a51e9f957229cc7a8bb0e2248167dedb252047c11e5790183738b4d1e694" => :mojave
    sha256 "a7274303c16fa42855699269a96e6fc3466371b68a8198c218d689a0ca39c1b8" => :high_sierra
  end

  depends_on "maven" => :build
  depends_on "openjdk"

  def install
    ENV["JAVA_HOME"] = Formula["openjdk"].opt_prefix

    # Homebrew's OpenJDK no longer accepts Java 5 source
    inreplace "pom.xml" do |s|
      s.gsub! "<source>1.5</source>", "<source>1.7</source>"
      s.gsub! "<target>1.5</target>", "<target>1.7</target>"
    end

    system "mvn", "clean", "package", "-DskipTests=true", "-Dmaven.javadoc.skip=true"
    libexec.install Dir["target/htmlcleaner-*.jar"]
    bin.write_jar_script libexec/"htmlcleaner-#{version}.jar", "htmlcleaner"
  end

  test do
    path = testpath/"index.html"
    path.write "<html>"
    assert_match "</html>", shell_output("#{bin}/htmlcleaner src=#{path}")
  end
end
