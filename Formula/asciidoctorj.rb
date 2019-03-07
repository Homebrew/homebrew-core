class Asciidoctorj < Formula
  desc "Java wrapper and bindings for Asciidoctor"
  homepage "https://github.com/asciidoctor/asciidoctorj"
  url "https://dl.bintray.com/asciidoctor/maven/org/asciidoctor/asciidoctorj/1.6.2/asciidoctorj-1.6.2-bin.zip"
  sha256 "b42f0efc4f61c57c5638b6e3aff746bb4df825c0d1824ad3065763e9aed2945c"

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
