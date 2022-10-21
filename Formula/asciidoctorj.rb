class Asciidoctorj < Formula
  desc "Java wrapper and bindings for Asciidoctor"
  homepage "https://github.com/asciidoctor/asciidoctorj"
  url "https://search.maven.org/remotecontent?filepath=org/asciidoctor/asciidoctorj/2.5.7/asciidoctorj-2.5.7-bin.zip"
  sha256 "e25292735620cbb31af11e2fc730b52d9dac35a68f2f2f7ca4ee5aef0dfb7c37"
  license "Apache-2.0"

  livecheck do
    url "https://search.maven.org/remotecontent?filepath=org/asciidoctor/asciidoctorj/maven-metadata.xml"
    regex(%r{<version>v?(\d+(?:\.\d+)+)</version>}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "b9950eb37c437734fc17d9c8b01be3918272c5c2a71c1f525a538a46fa288409"
  end

  depends_on "openjdk"

  def install
    rm_rf Dir["bin/*.bat"] # Remove Windows files.
    libexec.install Dir["*"]
    (bin/"asciidoctorj").write_env_script libexec/"bin/asciidoctorj", JAVA_HOME: Formula["openjdk"].opt_prefix
  end

  test do
    (testpath/"test.adoc").write <<~EOS
      = AsciiDoc is Writing Zen
      Random J. Author <rjauthor@example.com>
      :icons: font

      Hello, World!

      == Syntax Highlighting

      Python source.

      [source, python]
      ----
      import something
      ----

      List

      - one
      - two
      - three
    EOS
    system bin/"asciidoctorj", "-b", "html5", "-o", "test.html", "test.adoc"
    assert_match "<h1>AsciiDoc is Writing Zen</h1>", File.read("test.html")
    system bin/"asciidoctorj", "-r", "asciidoctor-pdf", "-b", "pdf", "-o", "test.pdf", "test.adoc"
    assert_match "/Title (AsciiDoc is Writing Zen)", File.read("test.pdf", mode: "rb")
  end
end
