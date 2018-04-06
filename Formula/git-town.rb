class GitTown < Formula
  desc "High-level command-line interface for Git"
  homepage "http://www.git-town.com"
  url "https://github.com/Originate/git-town/archive/v7.1.0.tar.gz"
  sha256 "4a40e4d97f3e6f04bada56ff56fc9776f8821ac982951ebc4429d1a334146810"

  bottle do
    cellar :any_skip_relocation
    sha256 "f305b095b9b7074ad58322865e7455c0eb766cc9405725cd4f242b490d597c9c" => :high_sierra
    sha256 "db7065cbcb3af23aa4cbdb52276c8088a42896609a18e6687b734ee42638c27f" => :sierra
    sha256 "fcd21c83daf8dce8cca4f60a237d25a03ab94eddea0edc9cd9bed18fffcf3c03" => :el_capitan
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
