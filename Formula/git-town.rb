class GitTown < Formula
  desc "High-level command-line interface for Git"
  homepage "http://www.git-town.com"
  url "https://github.com/Originate/git-town/archive/v6.0.0.tar.gz"
  sha256 "8e44875b39833ecb31a8e2159504bd76fd1c8f7a840233c6fa589f023ad5da45"

  bottle do
    cellar :any_skip_relocation
    sha256 "17bf26bc0a68b03bec2ba4450d0730fe1636e6db043d6064436038564fa58100" => :high_sierra
    sha256 "e967d48b8f65d1173965f3f8eabd95ba218d4224d83f4bd79f9d91dfb97fa66c" => :sierra
    sha256 "6fc6244729e3487901c5c6b4c7c35a390786ce648617b0f6a951fbabfce8155a" => :el_capitan
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
