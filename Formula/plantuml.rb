class Plantuml < Formula
  desc "Draw UML diagrams"
  homepage "https://plantuml.com/"
  url "https://downloads.sourceforge.net/project/plantuml/1.2019.0/plantuml.1.2019.0.jar"
  sha256 "767b2a3f5512ae0636fdaea8a54a58b96ffa8fd41933f941e6fb55bafed381e1"
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
