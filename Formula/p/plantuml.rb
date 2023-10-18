class Plantuml < Formula
  desc "Draw UML diagrams"
  homepage "https://plantuml.com/"
  url "https://github.com/plantuml/plantuml/releases/download/v1.2023.11/plantuml-1.2023.11.jar"
  sha256 "65c511b1fa896c3619d8b261c5f0392a786692a51388fadeb9f98cac2825f56a"
  license "GPL-3.0-or-later"
  version_scheme 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7a0b88dd46a6e6357f93e7e506729e09b6463648e3b3308f6c8bd2712e272e55"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7a0b88dd46a6e6357f93e7e506729e09b6463648e3b3308f6c8bd2712e272e55"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7a0b88dd46a6e6357f93e7e506729e09b6463648e3b3308f6c8bd2712e272e55"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7a0b88dd46a6e6357f93e7e506729e09b6463648e3b3308f6c8bd2712e272e55"
    sha256 cellar: :any_skip_relocation, sonoma:         "7a0b88dd46a6e6357f93e7e506729e09b6463648e3b3308f6c8bd2712e272e55"
    sha256 cellar: :any_skip_relocation, ventura:        "7a0b88dd46a6e6357f93e7e506729e09b6463648e3b3308f6c8bd2712e272e55"
    sha256 cellar: :any_skip_relocation, monterey:       "7a0b88dd46a6e6357f93e7e506729e09b6463648e3b3308f6c8bd2712e272e55"
    sha256 cellar: :any_skip_relocation, big_sur:        "7a0b88dd46a6e6357f93e7e506729e09b6463648e3b3308f6c8bd2712e272e55"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c0dc3b434a2bea40cc296ef3a51ac8d7cdf747390aff8b1499162f23f3fd0f00"
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
