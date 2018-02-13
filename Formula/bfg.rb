class Bfg < Formula
  desc "Remove large files or passwords from Git history like git-filter-branch"
  homepage "https://rtyley.github.io/bfg-repo-cleaner/"
  url "https://search.maven.org/remotecontent?filepath=com/madgag/bfg/1.13.0/bfg-1.13.0.jar"
  sha256 "bf22bab9dd42d4682b490d6bc366afdad6c3da99f97521032d3be8ba7526c8ce"

  bottle :unneeded

  depends_on :java => "1.7+"

  def install
    libexec.install "bfg-#{version}.jar"
    bin.write_jar_script libexec/"bfg-#{version}.jar", "bfg"
  end

  test do
    system "#{bin}/bfg"
  end
end
