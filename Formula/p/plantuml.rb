class Plantuml < Formula
  desc "Draw UML diagrams"
  homepage "https://plantuml.com/"
  url "https://github.com/plantuml/plantuml/releases/download/v1.2023.10/plantuml-1.2023.10.jar"
  sha256 "ee06454723028763dd8280459e8fd8f31fcd85b1ae8d9ab0e32122243c098c3b"
  license "GPL-3.0-or-later"
  version_scheme 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d23fe00fff2988d3f4cc6ca8ec24134a9f8b2cffbe0bb8c30f313808603a3bce"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d23fe00fff2988d3f4cc6ca8ec24134a9f8b2cffbe0bb8c30f313808603a3bce"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d23fe00fff2988d3f4cc6ca8ec24134a9f8b2cffbe0bb8c30f313808603a3bce"
    sha256 cellar: :any_skip_relocation, ventura:        "d23fe00fff2988d3f4cc6ca8ec24134a9f8b2cffbe0bb8c30f313808603a3bce"
    sha256 cellar: :any_skip_relocation, monterey:       "d23fe00fff2988d3f4cc6ca8ec24134a9f8b2cffbe0bb8c30f313808603a3bce"
    sha256 cellar: :any_skip_relocation, big_sur:        "d23fe00fff2988d3f4cc6ca8ec24134a9f8b2cffbe0bb8c30f313808603a3bce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1949d14953764e59cb5e7271408bdfefd9bced0cf0f00b6ae40d9fe9b96fc3a1"
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
