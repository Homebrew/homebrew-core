class GitTown < Formula
  desc "High-level command-line interface for Git"
  homepage "https://www.git-town.com/"
  url "https://github.com/Originate/git-town/archive/v7.3.0.tar.gz"
  sha256 "dcfb61266f2f1fcbc609a52a97d3975ac9bc8860dce90fc98a76f5b1b0bd2142"

  bottle do
    cellar :any_skip_relocation
    sha256 "9d756be0c03322770b3ef08f71a356dcf3b7f9effa3f366d8818547a32d6629e" => :catalina
    sha256 "acdbaa473264c569f1d2f2cfe6c6486ff02f6af601e800e0cb0a350ef0c32154" => :mojave
    sha256 "b3be72d926d402afe2ae9b079bd702095729372b7a142d1ade13367a8415cf43" => :high_sierra
    sha256 "423e9c2afbde04439ce9689942b739806b5ae97941d92d9ae4d2f9c7f4295047" => :sierra
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
