class Plantuml < Formula
  desc "Draw UML diagrams"
  homepage "https://plantuml.com/"
  url "https://github.com/plantuml/plantuml/releases/download/v1.2026.10/plantuml-1.2026.10.jar"
  sha256 "e9bc9e6b2eb715e8c0c929f3dcb5fc1923be13f37599b09c293c66d354e88686"
  license "GPL-3.0-or-later"
  version_scheme 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "34ee70d40f7c24c9bc9ec1a0c7c5bd21ae223687ab2862350d488b01180a973c"
  end

  depends_on "graphviz"
  depends_on "openjdk"

  def install
    jar = "plantuml.jar"
    libexec.install "plantuml-#{version}.jar" => jar
    (bin/"plantuml").write <<~BASH
      #!/bin/bash
      if [[ "$*" != *"-gui"* ]]; then
        VMARGS="-Djava.awt.headless=true"
      fi
      GRAPHVIZ_DOT="#{formula_opt_bin("graphviz")}/dot" exec "#{formula_opt_bin("openjdk")}/java" $VMARGS -jar #{libexec}/#{jar} "$@"
    BASH
    chmod 0755, bin/"plantuml"
  end

  test do
    system bin/"plantuml", "-testdot"
  end
end
