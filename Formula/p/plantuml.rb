class Plantuml < Formula
  desc "Draw UML diagrams"
  homepage "https://plantuml.com/"
  url "https://github.com/plantuml/plantuml/releases/download/v1.2024.6/plantuml-1.2024.6.jar"
  sha256 "5a8dc3b37fe133a4744e55be80caf6080a70350aba716d95400a0f0cbd79e846"
  license "GPL-3.0-or-later"
  version_scheme 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0492d42c32b924bc419258fcab1fffa0f53bca721198f279f380a1c731375e40"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0492d42c32b924bc419258fcab1fffa0f53bca721198f279f380a1c731375e40"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0492d42c32b924bc419258fcab1fffa0f53bca721198f279f380a1c731375e40"
    sha256 cellar: :any_skip_relocation, sonoma:         "0492d42c32b924bc419258fcab1fffa0f53bca721198f279f380a1c731375e40"
    sha256 cellar: :any_skip_relocation, ventura:        "0492d42c32b924bc419258fcab1fffa0f53bca721198f279f380a1c731375e40"
    sha256 cellar: :any_skip_relocation, monterey:       "0492d42c32b924bc419258fcab1fffa0f53bca721198f279f380a1c731375e40"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "41fddbfe48d1c936259b4f57f677f8503bd2b7b5e49564455cf0dc1da22921ef"
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
