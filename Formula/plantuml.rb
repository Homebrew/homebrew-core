class Plantuml < Formula
  desc "Draw UML diagrams"
  homepage "https://plantuml.com/"
  url "https://downloads.sourceforge.net/project/plantuml/1.2018.8/plantuml.1.2018.8.jar"
  sha256 "31e63ec8f438fba3f02246d3b9f7c589518e073c85f8384469a2477519685b0b"
  version_scheme 1

  bottle :unneeded

  option "with-pdf-support", "Downloads additional JAR files for PDF export functionality"

  depends_on "graphviz"
  depends_on :java

  resource "batik-and-fop" do
    url "http://beta.plantuml.net/batikAndFop.zip"
    sha256 "c1f328a9aacfd954c6cd90650cefd924baea358d6e27520de7ccf9b30a681877"
  end

  def install
    jar = "plantuml.jar"
    libexec.install "plantuml.#{version}.jar" => jar
    (bin/"plantuml").write <<~EOS
      #!/bin/bash
      GRAPHVIZ_DOT="#{Formula["graphviz"].opt_bin}/dot" exec java -jar #{libexec}/#{jar} "$@"
    EOS
    chmod 0555, bin/"plantuml"
    libexec.install resource("batik-and-fop") if build.with? "pdf-support"
  end

  test do
    system bin/"plantuml", "-testdot"
  end
end
