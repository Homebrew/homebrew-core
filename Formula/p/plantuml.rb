class Plantuml < Formula
  desc "Draw UML diagrams"
  homepage "https://plantuml.com/"
  url "https://github.com/plantuml/plantuml/releases/download/v1.2024.4/plantuml-1.2024.4.jar"
  sha256 "8575b3e224d9488c6a0bb6ba78ba64e76457dc9777c496e3fa9d8c67108369b7"
  license "GPL-3.0-or-later"
  version_scheme 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "6cfd5f9ac96a217e3c884e2fee4a769c4d47f6a79cbf5fe999c45b03e9176f80"
  end

  depends_on "graphviz"
  depends_on "openjdk"

  def install
    jar = "plantuml.jar"
    libexec.install "plantuml-#{version}.jar" => jar
    (bin/"plantuml").write <<~EOS
      #!/bin/bash
      if [[ "$*" != *"-gui"* ]]; then
        VMARGS="-Djava.awt.headless=true"
      fi
      GRAPHVIZ_DOT="#{Formula["graphviz"].opt_bin}/dot" exec "#{Formula["openjdk"].opt_bin}/java" $VMARGS -jar #{libexec}/#{jar} "$@"
    EOS
    chmod 0755, bin/"plantuml"
  end

  test do
    system bin/"plantuml", "-testdot"
  end
end
