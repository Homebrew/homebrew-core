class GitTown < Formula
  desc "High-level command-line interface for Git"
  homepage "http://www.git-town.com"
  url "https://github.com/Originate/git-town/archive/v6.0.2.tar.gz"
  sha256 "a2438914cc406a92c23b3d1de4d0fe2536f982d680331643819c3a0f06b0a26b"

  bottle do
    cellar :any_skip_relocation
    sha256 "76f3d3e2cf6ea9b6026cc9521e5be5a5dd81d671a291e47d82763288d6f8ba76" => :high_sierra
    sha256 "28320a9c1c3c6fee0b1d5fa724130bdc00b65d7f83d91973fc94047601ea1554" => :sierra
    sha256 "636f1e8d156ef3c91a05a4d2b3a296bc1480ed7832ee478af18c4bdc3e8b9a89" => :el_capitan
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
