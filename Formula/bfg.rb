class Bfg < Formula
  desc "Remove large files or passwords from Git history like git-filter-branch"
  homepage "https://rtyley.github.io/bfg-repo-cleaner/"
  url "https://search.maven.org/remotecontent?filepath=com/madgag/bfg/1.12.16/bfg-1.12.16.jar"
  sha256 "6bf2119985eb937d43b036aa4707ac701f0aa56ccb7cefdc71a9355824a6a7e7"

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
