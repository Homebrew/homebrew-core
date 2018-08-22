class GitTown < Formula
  desc "High-level command-line interface for Git"
  homepage "https://www.git-town.com/"
  url "https://github.com/Originate/git-town/archive/v7.2.0.tar.gz"
  sha256 "0462ed11954332960e42b5dfccbe3ac99d6df488cd60ffd4be6e81745daaf103"

  bottle do
    cellar :any_skip_relocation
    sha256 "92df7335bdb79d012d3afdfe587bc1f66f1e4bf7090fcbcef172aac21d84a8c3" => :mojave
    sha256 "a9e27d5e017d5f51c8ea3b0c2f6b0d86a2116ad48e3e62f1d578342a8a090a6e" => :high_sierra
    sha256 "075e79a6f84fb0c8c94d3ba5e257c6810ac931416aead433b26cea74f04a247d" => :sierra
    sha256 "c81d209749ca5f493bb8efc8207894b44ebf2b64eb766c70e9fba3e278132f3c" => :el_capitan
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
