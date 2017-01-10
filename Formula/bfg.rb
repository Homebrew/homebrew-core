class Bfg < Formula
  desc "Remove large files or passwords from Git history like git-filter-branch"
  homepage "https://rtyley.github.io/bfg-repo-cleaner/"
  url "https://search.maven.org/remotecontent?filepath=com/madgag/bfg/1.12.14/bfg-1.12.14.jar"
  sha256 "59059fdb9220172be229b4d1e2eda68ab0c280da3f0897f0b2c1f224645f7b40"

  bottle :unneeded

  depends_on :java => "1.7+"

  def install
    libexec.install "bfg-1.12.13.jar"
    bin.write_jar_script libexec/"bfg-1.12.13.jar", "bfg"
  end

  test do
    system "#{bin}/bfg"
  end
end
