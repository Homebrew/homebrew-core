class Bfg < Formula
  desc "Remove large files or passwords from Git history like git-filter-branch"
  homepage "https://rtyley.github.io/bfg-repo-cleaner/"
  url "https://search.maven.org/remotecontent?filepath=com/madgag/bfg/1.12.14/bfg-1.12.14.jar"
  sha256 "7a44d53ef626a4282c34cc363166e678c5d9e91e4c6815e8e069036edd9fab64"

  bottle :unneeded

  depends_on :java => "1.7+"

  def install
    libexec.install "bfg-1.12.14.jar"
    bin.write_jar_script libexec/"bfg-1.12.14.jar", "bfg"
  end

  test do
    system "#{bin}/bfg"
  end
end
