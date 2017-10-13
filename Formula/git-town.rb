class GitTown < Formula
  desc "High-level command-line interface for Git"
  homepage "http://www.git-town.com"
  url "https://github.com/Originate/git-town/archive/v5.0.0.tar.gz"
  sha256 "ecce199e1784fa59c4735c793632d691d0be2f7385dbdffc661cedc4a6f51704"

  bottle do
    cellar :any_skip_relocation
    sha256 "e2ab2cec3f6b43790934366d463e56dbc9bb2cdf4353da4bb76097b54b640a5e" => :high_sierra
    sha256 "2b7f7e0c56371762d7dda2599f9c0d42dbc3cb00a3a8dfbf986ca568b8d4396c" => :sierra
    sha256 "cece6487b0a58126b108af4827328c6af9f79b9bf6867ae0ce92460071de6a2f" => :el_capitan
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
