class Htmlcleaner < Formula
  desc "HTML parser written in Java"
  homepage "https://htmlcleaner.sourceforge.io"
  url "https://downloads.sourceforge.net/project/htmlcleaner/htmlcleaner/htmlcleaner%20v2.27/htmlcleaner-2.27-src.zip"
  sha256 "908a837f55760e8aa72f3ac516b66f2216d2b99b9b3bede56a767966401b75c4"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cd72cf3dcc385cb161e665ce3f12ac69903b826a53a48d0fd1589ee856b80c21"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dfc9b54998f3ae300598bf80cb893c99a9a07692daa917f18ef8cc00519536bc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d1ac0c73ac0937b77c13445d22d5a37938ac6ebcabb6f7edcc56af00e42dd74c"
    sha256 cellar: :any_skip_relocation, ventura:        "9517578772834a78da9f419ca4f104a8b30ee8b986a4fe246df6d0d8964763d0"
    sha256 cellar: :any_skip_relocation, monterey:       "ef5aadaf721830eed7f446ea68dc807559c6fe6409a757171a8fa6878979da4e"
    sha256 cellar: :any_skip_relocation, big_sur:        "f6b01eb50b83f19154955d6934690a72f0b99aaa6202353bab8c97ebb9ebf7e5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7774e9ca1d451d880879b0327d84d531faa2341b987a47e23319fa45a5b3a87b"
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
