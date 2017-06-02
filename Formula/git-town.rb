class GitTown < Formula
  desc "High-level command-line interface for Git"
  homepage "http://www.git-town.com"
  url "https://github.com/Originate/git-town/archive/v4.0.1.tar.gz"
  sha256 "b30488ca1b6ea7e5502221d22abacc1b0f2f1ed1421761afb6daa539de8ac1fb"

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
