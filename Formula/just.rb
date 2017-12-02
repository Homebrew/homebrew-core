class Just < Formula
  desc "Handy way to save and run project-specific commands"
  homepage "https://github.com/casey/just"
  url "https://github.com/casey/just/archive/v0.3.4.tar.gz"
  sha256 "54d0a366614df5274892a48c7af50a7fae6d791ddeb7a256a9b60d0217a90abc"

  bottle do
    sha256 "01d35e67939237c26067f3661d422e641c590f5f2938401da328b61a40f55392" => :high_sierra
    sha256 "e23358ff8d5d5e32b95029d7345524af0d7fb74db78e2317b6800bd70b4651c6" => :sierra
    sha256 "27b2a94ba75f406f6b555d9fb02a819efc5ce1992d1012d78f34a6991c5429e6" => :el_capitan
  end

  depends_on "rust" => :build

  def install
    system "cargo", "build", "--release"
    bin.install "target/release/just"
  end

  test do
    (testpath/"justfile").write <<~EOS
      default:
        touch it-worked
    EOS
    system "#{bin}/just"
    assert_predicate testpath/"it-worked", :exist?
  end
end
