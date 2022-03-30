class Plantuml < Formula
  desc "Draw UML diagrams"
  homepage "https://plantuml.com/"
  url "https://downloads.sourceforge.net/project/plantuml/1.2022.3/plantuml.1.2022.3.jar"
  sha256 "bb8d0fdd816259de35f41cf536f848b0f6bb9c04a5fc8f73fcbd90e6ff5e380a"
  license "GPL-3.0-or-later"
  version_scheme 1

  livecheck do
    url :stable
    regex(%r{url=.*?/plantuml[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e55169886ad5305d0d88334802e6096801e1876cff7084df6270464043489746"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ab40c04370a035d4e54710121b88e517ef3182396bcdf7cd1910922db55af7eb"
    sha256 cellar: :any_skip_relocation, monterey:       "251c273199fcd2965c0b1b3e85cfed5fcdc7eb5cfeaeeceae5d976078177cbc5"
    sha256 cellar: :any_skip_relocation, big_sur:        "938715d30def6672c8c2783e34cbf4021fe667f2f9fcd4b529202f4077d9a387"
    sha256 cellar: :any_skip_relocation, catalina:       "5855139986b8826f4dd8ea671aa4da0cc6319be2b08d2b245d264195db5077b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "80879633e2aef94bfcd75c387ed10f126d0cf22ca4d299a0be565036929c5ad8"
  end

  depends_on "graphviz"
  depends_on "openjdk"

  def install
    jar = "plantuml.jar"
    libexec.install "plantuml.#{version}.jar" => jar
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
