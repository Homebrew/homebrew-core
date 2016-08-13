class Plantuml < Formula
  desc "Draw UML diagrams"
  homepage "http://plantuml.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/plantuml/plantuml.8046.jar"
  sha256 "136997cd0d5c40b71b5cf9f45b5f1e93d3dbfa6c67b57a3679a628183c6f236e"

  bottle :unneeded

  depends_on "graphviz"

  def install
    jar = "plantuml.#{version}.jar"
    prefix.install jar
    (bin/"plantuml").write <<-EOS.undent
      #!/bin/bash
      GRAPHVIZ_DOT="#{Formula["graphviz"].opt_bin}/dot" exec java -jar #{prefix}/#{jar} "$@"
    EOS
  end

  test do
    system bin/"plantuml", "-testdot"
  end
end
