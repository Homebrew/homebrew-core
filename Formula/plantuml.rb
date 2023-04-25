class Plantuml < Formula
  desc "Draw UML diagrams"
  homepage "https://plantuml.com/"
  url "https://github.com/plantuml/plantuml/releases/download/v1.2023.6/plantuml-1.2023.6.jar"
  sha256 "bf2dee10750fd1794ad9eac7de020064d113838ec169448a16b639dbfb67617d"
  license "GPL-3.0-or-later"
  version_scheme 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "abb4adcc1b63f4f1e2caf2ec1b842114529029c9766f019de32219b9037da530"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "abb4adcc1b63f4f1e2caf2ec1b842114529029c9766f019de32219b9037da530"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "abb4adcc1b63f4f1e2caf2ec1b842114529029c9766f019de32219b9037da530"
    sha256 cellar: :any_skip_relocation, ventura:        "abb4adcc1b63f4f1e2caf2ec1b842114529029c9766f019de32219b9037da530"
    sha256 cellar: :any_skip_relocation, monterey:       "abb4adcc1b63f4f1e2caf2ec1b842114529029c9766f019de32219b9037da530"
    sha256 cellar: :any_skip_relocation, big_sur:        "abb4adcc1b63f4f1e2caf2ec1b842114529029c9766f019de32219b9037da530"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5e06a16a51609167f82431ba48f16955f2fd9d65c36137805f8a24641482e5cb"
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
