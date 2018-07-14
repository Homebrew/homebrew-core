class Asciidoctorj < Formula
  desc "Java wrapper and bindings for Asciidoctor"
  homepage "https://github.com/asciidoctor/asciidoctorj"
  url "https://dl.bintray.com/asciidoctor/maven/org/asciidoctor/asciidoctorj/1.5.7/asciidoctorj-1.5.7-bin.zip"
  sha256 "b0295bb73589f389a6b62563e2fd018b0aa6095feacb5acfa7f534b1265e67d1"

  bottle :unneeded

  depends_on :java => "1.7+"

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
    # Absolute path to input file is required to work around upstream bug
    # https://github.com/asciidoctor/asciidoctorj/issues/662
    system bin/"asciidoctorj", "-b", "pdf", testpath/"test.adoc"
    assert_predicate testpath/"test.pdf", :exist?
  end
end
