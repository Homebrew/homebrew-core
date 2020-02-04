class Bfg < Formula
  desc "Remove large files or passwords from Git history like git-filter-branch"
  homepage "https://rtyley.github.io/bfg-repo-cleaner/"
  url "https://search.maven.org/remotecontent?filepath=com/madgag/bfg/1.13.0/bfg-1.13.0.jar"
  sha256 "bf22bab9dd42d4682b490d6bc366afdad6c3da99f97521032d3be8ba7526c8ce"
  revision 1

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
