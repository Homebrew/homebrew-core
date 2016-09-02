class Bfg < Formula
  desc "Remove large files or passwords from Git history like git-filter-branch"
  homepage "https://rtyley.github.io/bfg-repo-cleaner/"
  url "https://search.maven.org/remotecontent?filepath=com/madgag/bfg/1.12.13/bfg-1.12.13.jar"
  sha256 "fbeb45314d45c7ff26bb513154675a2e1e822282e0d095c6d911fcf68fd089c0"

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
