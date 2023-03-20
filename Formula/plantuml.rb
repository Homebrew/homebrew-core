class Plantuml < Formula
  desc "Draw UML diagrams"
  homepage "https://plantuml.com/"
  url "https://github.com/plantuml/plantuml/releases/download/v1.2023.4/plantuml-1.2023.4.jar"
  sha256 "3a659c3d87ea5ebac7aadb645233176c51d0290777ebc28285dd2a35dc947752"
  license "GPL-3.0-or-later"
  version_scheme 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "79474cd5a2dfe757efe776e3d31b769fba1e99ffee53385850ee17ee29fbe36d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "79474cd5a2dfe757efe776e3d31b769fba1e99ffee53385850ee17ee29fbe36d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "79474cd5a2dfe757efe776e3d31b769fba1e99ffee53385850ee17ee29fbe36d"
    sha256 cellar: :any_skip_relocation, ventura:        "79474cd5a2dfe757efe776e3d31b769fba1e99ffee53385850ee17ee29fbe36d"
    sha256 cellar: :any_skip_relocation, monterey:       "79474cd5a2dfe757efe776e3d31b769fba1e99ffee53385850ee17ee29fbe36d"
    sha256 cellar: :any_skip_relocation, big_sur:        "79474cd5a2dfe757efe776e3d31b769fba1e99ffee53385850ee17ee29fbe36d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8e06cad42d51381d3ff3d36f742b3bd3d5f1cda62e8f0b3db809b3935ecc0184"
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
