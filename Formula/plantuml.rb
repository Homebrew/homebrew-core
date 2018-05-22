class Plantuml < Formula
  desc "Draw UML diagrams"
  homepage "https://plantuml.com/"
  url "https://downloads.sourceforge.net/project/plantuml/1.2018.6/plantuml.1.2018.6.jar"
  sha256 "ae2fe3d858aff9e1738662ed2c28a17bffbeec158e2c85e255bc93430722eef1"
  version_scheme 1

  bottle :unneeded

  depends_on "graphviz"
  depends_on :java

  def install
    jar = "plantuml.jar"
    libexec.install "plantuml.#{version}.jar" => jar
    (bin/"plantuml").write <<~EOS
      #!/bin/bash
      GRAPHVIZ_DOT="#{Formula["graphviz"].opt_bin}/dot" exec java -jar #{libexec}/#{jar} "$@"
    EOS
    chmod 0555, bin/"plantuml"
  end

  test do
    system bin/"plantuml", "-testdot"
  end
end
