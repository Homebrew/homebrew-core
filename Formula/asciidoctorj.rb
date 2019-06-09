class Asciidoctorj < Formula
  desc "Java wrapper and bindings for Asciidoctor"
  homepage "https://github.com/asciidoctor/asciidoctorj"
  url "https://dl.bintray.com/asciidoctor/maven/org/asciidoctor/asciidoctorj/2.0.0/asciidoctorj-2.0.0-bin.zip"
  sha256 "218696f6d411a43b17685704e5d45ce4220c52e78ee05983fefb7ac247a9881d"

  bottle :unneeded

  depends_on :java => "1.6+"

  def install
    rm_rf Dir["bin/*.bat"] # Remove Windows files.
    libexec.install Dir["*"]

    executable = libexec/"bin/asciidoctorj"
    executable.chmod 0555
    bin.write_exec_script executable
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
