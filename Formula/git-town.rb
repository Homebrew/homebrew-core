class GitTown < Formula
  desc "High-level command-line interface for Git"
  homepage "http://www.git-town.com"
  url "https://github.com/Originate/git-town/archive/v6.0.2.tar.gz"
  sha256 "a2438914cc406a92c23b3d1de4d0fe2536f982d680331643819c3a0f06b0a26b"

  bottle do
    cellar :any_skip_relocation
    sha256 "655d258505b9eb3f769a813ee6a974e960cd63f3ae976541c3dcbe57e44bc1c7" => :high_sierra
    sha256 "3d32e10e3bc2b428cae644032864833e637b3107c842cd2390a03fe2ff01843f" => :sierra
    sha256 "23c4c4d4c50f0dd5382627d284507d520b725047b6ce00820442f30ae2df5125" => :el_capitan
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
