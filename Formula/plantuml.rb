class Plantuml < Formula
  desc "Draw UML diagrams"
  homepage "https://plantuml.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/plantuml/plantuml.8057.jar"
  sha256 "5519dea83f6a3890cee67655a51932aa0fe6c50000890e5723255cd05f8e0af7"

  bottle :unneeded

  depends_on "graphviz"
  depends_on :java

  def install
    jar = "plantuml.jar"
    libexec.install "plantuml.#{version}.jar" => jar
    (bin/"plantuml").write <<-EOS.undent
      #!/bin/bash
      GRAPHVIZ_DOT="#{Formula["graphviz"].opt_bin}/dot" exec java -jar #{libexec}/#{jar} "$@"
    EOS
    chmod 0555, bin/"plantuml"
  end

  test do
    system bin/"plantuml", "-testdot"
  end
end
