class Bfg < Formula
  desc "Remove large files or passwords from Git history like git-filter-branch"
  homepage "https://rtyley.github.io/bfg-repo-cleaner/"
  url "https://search.maven.org/remotecontent?filepath=com/madgag/bfg/1.13.1/bfg-1.13.1.jar"
  sha256 "e5b3d90e45cafb6687a7c8f56b01aeb437705e52cb4cc6bfe010f2a728cd2c26"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://github.com/rtyley/bfg-repo-cleaner.git"
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle :unneeded

  depends_on "openjdk"

  def install
    libexec.install "bfg-#{version}.jar"
    (bin/"bfg").write <<~EOS
      #!/bin/bash
      exec "#{Formula["openjdk"].opt_bin}/java" -jar "#{libexec}/bfg-#{version}.jar" "$@"
    EOS
  end

  test do
    system "#{bin}/bfg"
  end
end
