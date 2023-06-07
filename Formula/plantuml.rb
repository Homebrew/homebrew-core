class Plantuml < Formula
  desc "Draw UML diagrams"
  homepage "https://plantuml.com/"
  url "https://github.com/plantuml/plantuml/releases/download/v1.2023.8/plantuml-1.2023.8.jar"
  sha256 "4d4084ce85dbb1072fb2cfeae5100ef3a7b712e17b54b87eb612593e74d62f1f"
  license "GPL-3.0-or-later"
  version_scheme 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dc6d8f807f0c5328d32a9a2bb777a463b7802d001400ae79d768c1dc3de816a2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dc6d8f807f0c5328d32a9a2bb777a463b7802d001400ae79d768c1dc3de816a2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "dc6d8f807f0c5328d32a9a2bb777a463b7802d001400ae79d768c1dc3de816a2"
    sha256 cellar: :any_skip_relocation, ventura:        "dc6d8f807f0c5328d32a9a2bb777a463b7802d001400ae79d768c1dc3de816a2"
    sha256 cellar: :any_skip_relocation, monterey:       "dc6d8f807f0c5328d32a9a2bb777a463b7802d001400ae79d768c1dc3de816a2"
    sha256 cellar: :any_skip_relocation, big_sur:        "dc6d8f807f0c5328d32a9a2bb777a463b7802d001400ae79d768c1dc3de816a2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8c58899f8702c0275b6d9705321408bf644a53ad3a9acbf01a6add9cba074c7a"
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
