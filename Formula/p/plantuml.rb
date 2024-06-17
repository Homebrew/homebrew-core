class Plantuml < Formula
  desc "Draw UML diagrams"
  homepage "https://plantuml.com/"
  url "https://github.com/plantuml/plantuml/releases/download/v1.2024.5/plantuml-1.2024.5.jar"
  sha256 "3c551212da4aa421a2c2940b8cfae26951b3591f75d5b93e33775e930641c7db"
  license "GPL-3.0-or-later"
  version_scheme 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c1419a93cd413b18e405195481fbb52a2c9502fa55d86341ea89d13a2278f7b0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "23e3b4e71bc8321cba4d8f57607c43011e222539bfc8e1857613c6e3a7faf290"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5cd1e3963619bf85e8d57a4ab92cad35185141d2b62dde7473a57333b7382dba"
    sha256 cellar: :any_skip_relocation, sonoma:         "83d578ffb2823c40bdd2afa956aed301bcda14272a7ad908f4342d2cf98694c2"
    sha256 cellar: :any_skip_relocation, ventura:        "068d40e1e79bf45e2614bd66dcdb0e671be18e9e3dff20e9bb86523d07f1ba00"
    sha256 cellar: :any_skip_relocation, monterey:       "d7173cd22f8d879dbf054ce3c63f58a9b7e38bc4814c6ec45b52c749985cc0f1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9d3b563ab40e785a91dc12f35c605f53afd0d18cb82e09d457290c5533f7c8e4"
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
