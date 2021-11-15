class Htmlcleaner < Formula
  desc "HTML parser written in Java"
  homepage "https://htmlcleaner.sourceforge.io"
  url "https://downloads.sourceforge.net/project/htmlcleaner/htmlcleaner/htmlcleaner%20v2.25/htmlcleaner-2.25-src.zip"
  sha256 "3a2d4992d7fa0b687923e62fc1826df6ef5031e16734dba65cac86fe5dd3e7da"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "37911419908b9b5f70a5cd396af228ec25212bdd9978b065a018c6fb12390532"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7d7a502fca2bac395b425205c03b2d235e86784f77b8f99ab95c9cfbab176060"
    sha256 cellar: :any_skip_relocation, monterey:       "fd48d3e3bd93cdc8f54caea62c155b9d7b3ee76b6ae81a1f5c8e0effa8e39353"
    sha256 cellar: :any_skip_relocation, big_sur:        "a2d9a88a2165d4d91b9f5475d15c980f63a587fbbc95b2f4f95bd8eab3287497"
    sha256 cellar: :any_skip_relocation, catalina:       "3e58d6bd6a0c32df369f4fc7cbdd26b915ebd9f9625bd364f40573b04b759c87"
    sha256 cellar: :any_skip_relocation, mojave:         "8f7e5087d125f1d7d55397ce6ba4cea8cddbeb2e18639ca645fe81088d756938"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "295b57eb7ce2215b0346b061a2a412f17c13acc7f9cc65ce4ee2925a30d027ec"
  end

  depends_on "maven" => :build
  depends_on "openjdk"

  def install
    ENV["JAVA_HOME"] = Formula["openjdk"].opt_prefix

    inreplace "pom.xml" do |s|
      # Homebrew's OpenJDK no longer accepts Java 5 source
      s.gsub! "<source>1.5</source>", "<source>1.7</source>"
      s.gsub! "<target>1.5</target>", "<target>1.7</target>"
      # OpenJDK >14 doesn't support older maven-javadoc-plugin versions
      s.gsub! "<version>2.9</version>", "<version>3.2.0</version>"
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
