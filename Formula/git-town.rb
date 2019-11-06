class GitTown < Formula
  desc "High-level command-line interface for Git"
  homepage "https://www.git-town.com/"
  url "https://github.com/Originate/git-town/archive/v7.2.1.tar.gz"
  sha256 "67e061d34e6102755a4cd3f7b438487f7f5165be1836b8c26f46d5e2e8e3a121"

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
