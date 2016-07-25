class Plantuml < Formula
  desc "Draw UML diagrams"
  homepage "http://plantuml.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/plantuml/plantuml.8041.jar"
  sha256 "8964b8ea316e37492d9a4533a57338c46f629cdd920d48ddae53e2b62f5b6c8d"

  bottle :unneeded

  depends_on "graphviz"

  def install
    jar = "plantuml.#{version}.jar"
    prefix.install jar
    (bin+"plantuml").write <<-EOS.undent
      #!/bin/bash
      GRAPHVIZ_DOT="#{Formula["graphviz"].opt_bin}/dot" exec java -jar #{prefix}/#{jar} "$@"
    EOS
  end

  test do
    system "#{bin}/plantuml", "-testdot"
  end
end
