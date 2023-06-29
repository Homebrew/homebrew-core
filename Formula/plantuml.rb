class Plantuml < Formula
  desc "Draw UML diagrams"
  homepage "https://plantuml.com/"
  url "https://github.com/plantuml/plantuml/releases/download/v1.2023.9/plantuml-1.2023.9.jar"
  sha256 "dbc4fe71dd3d50792a4f631f0a6c7dee7644563cd3daf0a3da39c1f112c08bf0"
  license "GPL-3.0-or-later"
  version_scheme 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "89ca1bb859169db555f0d9849c36df4297090ddd9708056d3e035fe1ea92bf7e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "89ca1bb859169db555f0d9849c36df4297090ddd9708056d3e035fe1ea92bf7e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "89ca1bb859169db555f0d9849c36df4297090ddd9708056d3e035fe1ea92bf7e"
    sha256 cellar: :any_skip_relocation, ventura:        "89ca1bb859169db555f0d9849c36df4297090ddd9708056d3e035fe1ea92bf7e"
    sha256 cellar: :any_skip_relocation, monterey:       "89ca1bb859169db555f0d9849c36df4297090ddd9708056d3e035fe1ea92bf7e"
    sha256 cellar: :any_skip_relocation, big_sur:        "89ca1bb859169db555f0d9849c36df4297090ddd9708056d3e035fe1ea92bf7e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b13ccdeb6a40b2ba6d4f6a4a727539624d190ac93c6dc2a4705703d016898e1d"
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
