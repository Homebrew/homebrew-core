class GitTown < Formula
  desc "High-level command-line interface for Git"
  homepage "http://www.git-town.com"
  url "https://github.com/Originate/git-town/archive/v4.0.0.tar.gz"
  sha256 "4145a77ee7fe1f4579d04dfcc0a4658a21db4e07e80d7dd79328162f12797193"

  bottle do
    cellar :any_skip_relocation
    sha256 "6d78506ef2ff7718979baf019039dc6a76d1f2d589f22f583a329312b7796584" => :sierra
    sha256 "3ceff065b52006cba4380dc589437f9a1c182d684082f2c71ff5ead55208b3d4" => :el_capitan
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
