class GitTown < Formula
  desc "High-level command-line interface for Git"
  homepage "http://www.git-town.com"
  url "https://github.com/Originate/git-town/archive/v4.1.0.tar.gz"
  sha256 "1fa52580a1c162da28f0530e455379c9ac7bd7663507497c70ac9aa90680f30a"

  bottle do
    cellar :any_skip_relocation
    sha256 "c1d8ae4daeca8318043ca93f121a68459b7ec27f751291875249f3870044ba6d" => :sierra
    sha256 "43ff6d7ceaeb9e085397b60485c6401de969c4ab9106f6422ce22a1db03cb89b" => :el_capitan
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
