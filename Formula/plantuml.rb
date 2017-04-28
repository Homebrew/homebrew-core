class Plantuml < Formula
  desc "Draw UML diagrams"
  homepage "http://plantuml.com/"
  url "https://downloads.sourceforge.net/project/plantuml/1.2017.12/plantuml.1.2017.12.jar"
  sha256 "3eb511e45c4b31666b365020ed046b4b670d877e248b6fa8d76ca2c9cbefc5ab"

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
