class Bfg < Formula
  desc "Remove large files or passwords from Git history like git-filter-branch"
  homepage "https://rtyley.github.io/bfg-repo-cleaner/"
  url "https://search.maven.org/remotecontent?filepath=com/madgag/bfg/1.15.0/bfg-1.15.0.jar"
  sha256 "dfe2885adc2916379093f02a80181200536856c9a987bf21c492e452adefef7a"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://search.maven.org/remotecontent?filepath=com/madgag/bfg/maven-metadata.xml"
    regex(%r{<version>v?(\d+(?:\.\d+)+)</version>}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "e6ab06431b47f90f783c186032521800d0fffb1f9fffb842c0de85e624d54d2d"
  end

  depends_on "openjdk"

  def install
    libexec.install "bfg-#{version}.jar"
    (bin/"bfg").write <<~SHELL
      #!/bin/bash
      exec "#{Formula["openjdk"].opt_bin}/java" -jar "#{libexec}/bfg-#{version}.jar" "$@"
    SHELL
  end

  test do
    system bin/"bfg"
  end
end
