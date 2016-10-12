class Plantuml < Formula
  desc "Draw UML diagrams"
  homepage "http://plantuml.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/plantuml/plantuml.8048.jar"
  sha256 "e500ea94600ecade4af7262b32ea20a1c884de0013f4a3f07aeae02d594424ab"

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
