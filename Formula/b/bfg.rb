class Bfg < Formula
  desc "Remove large files or passwords from Git history like git-filter-branch"
  homepage "https://rtyley.github.io/bfg-repo-cleaner/"
  url "https://search.maven.org/remotecontent?filepath=com/madgag/bfg/1.14.0/bfg-1.14.0.jar"
  sha256 "1a75e9390541f4b55d9c01256b361b815c1e0a263e2fb3d072b55c2911ead0b7"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://search.maven.org/remotecontent?filepath=com/madgag/bfg/maven-metadata.xml"
    regex(%r{<version>v?(\d+(?:\.\d+)+)</version>}i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "7020c645d5e8175b1055f5bf0c82eb101614706e07c7003c529ed95797d4c9b1"
  end

  depends_on "openjdk"

  def install
    libexec.install "bfg-#{version}.jar"
    (bin/"bfg").write <<~EOS
      #!/bin/bash
      exec "#{Formula["openjdk"].opt_bin}/java" -jar "#{libexec}/bfg-#{version}.jar" "$@"
    EOS
  end

  test do
    system bin/"bfg"
  end
end
