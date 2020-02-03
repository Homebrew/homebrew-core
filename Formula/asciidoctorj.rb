class Asciidoctorj < Formula
  desc "Java wrapper and bindings for Asciidoctor"
  homepage "https://github.com/asciidoctor/asciidoctorj"
  url "https://dl.bintray.com/asciidoctor/maven/org/asciidoctor/asciidoctorj/2.2.0/asciidoctorj-2.2.0-bin.zip"
  sha256 "d5240240a4e39f4f9c56abab2da3e960a4784b7d8e7befa323fc9f64890f0029"
  revision 1

  bottle :unneeded

  depends_on "openjdk"

  def install
    rm_rf Dir["bin/*.bat"] # Remove Windows files.
    libexec.install Dir["*"]
    (bin/"asciidoctorj").write_env_script libexec/"bin/asciidoctorj", :JAVA_HOME => Formula["openjdk"].opt_prefix
  end

  test do
    (testpath/"test.adoc").write <<~EOS
      = This Is A Title
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
    system bin/"asciidoctorj", "-b", "pdf", "test.adoc"
    assert_predicate testpath/"test.pdf", :exist?
  end
end
