class Htmlcleaner < Formula
  desc "HTML parser written in Java"
  homepage "https://htmlcleaner.sourceforge.io"
  url "https://downloads.sourceforge.net/project/htmlcleaner/htmlcleaner/htmlcleaner%20v2.27/htmlcleaner-2.27-src.zip"
  sha256 "908a837f55760e8aa72f3ac516b66f2216d2b99b9b3bede56a767966401b75c4"
  license "BSD-3-Clause"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3e4e96c68815b32fe13febdbbaa1d54cf2a39beb083c68a1143e21004cf546d5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d0f0e845b5a61a73964c6de8a3b3bd04b24da6ded8e79af0c08a148e16e2e133"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5e56750d0cd85612e16aecff49a1d2a1a9efffd4d385a1ae92995863f79266a1"
    sha256 cellar: :any_skip_relocation, ventura:        "4ad1e88b976feff5456e561030dc7f86ff1dd922e6e39de250d83744d736ee36"
    sha256 cellar: :any_skip_relocation, monterey:       "40182e82a4a0bf196628e9cd037750d04ab3004f32daca4a1349c95053ec860f"
    sha256 cellar: :any_skip_relocation, big_sur:        "552dd3af0c39fdf03647e4b8d0231c640a81d3437395b0259c718423613974f3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6f78a9dc82e5ed770ebac1d717569a68d106b008d9df9df108bc1a501017387b"
  end

  depends_on "maven" => :build
  depends_on "openjdk"

  def install
    ENV["JAVA_HOME"] = Formula["openjdk"].opt_prefix
    system "mvn", "clean", "package", "-DskipTests=true", "-Dmaven.javadoc.skip=true"
    libexec.install "target/htmlcleaner-#{version}.jar"
    bin.write_jar_script libexec/"htmlcleaner-#{version}.jar", "htmlcleaner"
  end

  test do
    path = testpath/"index.html"
    path.write "<html>"
    assert_match "</html>", shell_output("#{bin}/htmlcleaner src=#{path}")
  end
end
