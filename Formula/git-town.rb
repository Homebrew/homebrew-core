class GitTown < Formula
  desc "High-level command-line interface for Git"
  homepage "http://www.git-town.com"
  url "https://github.com/Originate/git-town/archive/v7.1.1.tar.gz"
  sha256 "55cebd4723170bc0df65ca76c34ba88d7d67c18240dd25569ade3ccbd0cf8bf3"

  bottle do
    cellar :any_skip_relocation
    sha256 "b17a93840ab8e6a3eb7a2bfd57e3b2cf17529e628bd2611fadf47a28b2213b56" => :high_sierra
    sha256 "120b374ac63bab390dc1ed010cbb88716b58470da2a2e413980bd1f3e87baf23" => :sierra
    sha256 "71e51bb0487289361bb2941af3b7f303e6c92914aa0e62bdc7aaf7810a6ce7c2" => :el_capitan
  end

  depends_on "go" => :build
  depends_on :macos => :el_capitan

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/Originate").mkpath
    ln_sf buildpath, buildpath/"src/github.com/Originate/git-town"
    system "go", "build", "-o", bin/"git-town"
  end

  test do
    system "git", "init"
    touch "testing.txt"
    system "git", "add", "testing.txt"
    system "git", "commit", "-m", "Testing!"

    system "#{bin}/git-town", "config"
  end
end
