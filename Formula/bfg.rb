class Bfg < Formula
  desc "Remove large files or passwords from Git history like git-filter-branch"
  homepage "https://rtyley.github.io/bfg-repo-cleaner/"
  url "https://search.maven.org/remotecontent?filepath=com/madgag/bfg/1.12.15/bfg-1.12.15.jar"
  sha256 "330af214a0fed320c591afc1046b0f31e8a438f290da09672973aeaa6411b09d"

  bottle :unneeded

  depends_on :java => "1.7+"

  def install
    libexec.install "bfg-1.12.15.jar"
    bin.write_jar_script libexec/"bfg-1.12.15.jar", "bfg"
  end

  test do
    system "#{bin}/bfg"
  end
end
