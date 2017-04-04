class Plantuml < Formula
  desc "Draw UML diagrams"
  homepage "https://plantuml.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/plantuml/plantuml.8059.jar"
  sha256 "99e71f31e41a91a766b06a3e70c4af12b501bd59cc0767066b181498bb2259ce"

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
