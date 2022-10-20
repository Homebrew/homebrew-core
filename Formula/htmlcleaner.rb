class Htmlcleaner < Formula
  desc "HTML parser written in Java"
  homepage "https://htmlcleaner.sourceforge.io"
  url "https://downloads.sourceforge.net/project/htmlcleaner/htmlcleaner/htmlcleaner%20v2.26/htmlcleaner-2.26-src.zip"
  sha256 "617ddb866530f512c2c6f6f89b40a9ac6e46bf515960c49f47d8d037adaf0e2c"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b6a287a43392e2a9ea253172a5000ff7da6f898dffda7c3052eda4ecdb91a961"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9db87bc977615b9bb0250f0dc9f735dcd3d20a0799700640afe80c9bb011dd29"
    sha256 cellar: :any_skip_relocation, monterey:       "6dd5433406edc84f3e175426793cc788d1edc8cae11bfacfbaf4431f39c631a9"
    sha256 cellar: :any_skip_relocation, big_sur:        "573b152655d4c622581d6dc5f73229271cfd4307b3dd4d63967d41b2c3da5ae9"
    sha256 cellar: :any_skip_relocation, catalina:       "03d164b2210190deecac6180af860948b1d4e09a318dce0bbe631b7e98f0d0a0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bc3f63cf7c8a4d264c34fe39dfc265422a15564e04ce5495ab9bc08c91838dbf"
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
