class Plantuml < Formula
  desc "Draw UML diagrams"
  homepage "https://plantuml.com/"
  url "https://github.com/plantuml/plantuml/releases/download/v1.2023.2/plantuml-1.2023.2.jar"
  sha256 "35c05c9f5d146c7f0fb7a3321482520c5260855dd07cc22b111c97665e63709c"
  license "GPL-3.0-or-later"
  version_scheme 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "369ef04c9d1683fd5c9859aaee715b68d0f2cc16ee3b38894491e0739065fd81"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "369ef04c9d1683fd5c9859aaee715b68d0f2cc16ee3b38894491e0739065fd81"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "369ef04c9d1683fd5c9859aaee715b68d0f2cc16ee3b38894491e0739065fd81"
    sha256 cellar: :any_skip_relocation, ventura:        "369ef04c9d1683fd5c9859aaee715b68d0f2cc16ee3b38894491e0739065fd81"
    sha256 cellar: :any_skip_relocation, monterey:       "369ef04c9d1683fd5c9859aaee715b68d0f2cc16ee3b38894491e0739065fd81"
    sha256 cellar: :any_skip_relocation, big_sur:        "369ef04c9d1683fd5c9859aaee715b68d0f2cc16ee3b38894491e0739065fd81"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "529f07e44a2e40797b7b75cb96c724a732df6cb1bff16bfc452c3c20ff4f11ca"
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
