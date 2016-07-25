class Bfg < Formula
  desc "Remove large files or passwords from Git history like git-filter-branch"
  homepage "https://rtyley.github.io/bfg-repo-cleaner/"
  url "https://search.maven.org/remotecontent?filepath=com/madgag/bfg/1.12.12/bfg-1.12.12.jar"
  sha256 "03291c9cd9cdc664104f49b22b76bd39edc73052936cbfd72fc8d8595971fd9a"

  bottle :unneeded

  depends_on :java => "1.7+"

  def install
    libexec.install "bfg-1.12.12.jar"
    bin.write_jar_script libexec/"bfg-1.12.12.jar", "bfg"
  end

  test do
    system "#{bin}/bfg"
  end
end
