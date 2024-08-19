class Asciidoctorj < Formula
  desc "Java wrapper and bindings for Asciidoctor"
  homepage "https://github.com/asciidoctor/asciidoctorj"
  url "https://search.maven.org/remotecontent?filepath=org/asciidoctor/asciidoctorj/2.5.13/asciidoctorj-2.5.13-bin.zip"
  sha256 "67b420378c2887fdb330de2eb2d614a249224532eccc26c6f2ebe8330f878c38"
  license "Apache-2.0"

  livecheck do
    url "https://search.maven.org/remotecontent?filepath=org/asciidoctor/asciidoctorj/maven-metadata.xml"
    regex(%r{<version>v?(\d+(?:\.\d+)+)</version>}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "58c7e7d35b5d68dfc78268d5e0c14b3b9ee98dccc84be799486e02ffe65b41e7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d9b38406298794d1fe1efcecb85d477df3c2cfe1141a6cf9bd6f23bb9434ee08"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "52e3a28381979604ccab85a23fb9038e3376a54f23cc1117d294743389205904"
    sha256 cellar: :any_skip_relocation, sonoma:         "0247c75cec9ca4f42901c88f912850a0c30700ad54353d78f59959b6da1efeed"
    sha256 cellar: :any_skip_relocation, ventura:        "aedf3aa3e1713a6d5793be0016600101116d26ffb34a7bdab659338797096a02"
    sha256 cellar: :any_skip_relocation, monterey:       "4652711e9d2d4579a4ceab8d4324e03b8f3aee712309f8098c1b8d8b739a5bd8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8a42d32e9cd644da5632b8f66d52f97ab57156d0229cf7f1f6e1f02b90e99e78"
  end

  depends_on "openjdk"

  def install
    rm_r(Dir["bin/*.bat"]) # Remove Windows files.
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
