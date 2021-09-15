class Jdupes < Formula
  desc "Duplicate file finder and an enhanced fork of 'fdupes'"
  homepage "https://github.com/jbruchon/jdupes"
  url "https://github.com/jbruchon/jdupes/archive/v1.20.0.tar.gz"
  sha256 "c1f728961ad8aeb074e5767367639e6b418f0ca572f70f7635655da722f1827e"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "694b8453af679ab4eb7a2e91263fcc76c392f818aed0a1b2b28be15ce27c850b"
    sha256 cellar: :any_skip_relocation, big_sur:       "5261ed3efa79bfe31ae62a82c90b656495ebd63bdf727b2cba5ef18a16347c1f"
    sha256 cellar: :any_skip_relocation, catalina:      "fae0c446827755c4fae47ad83f20f9930574eb2f29a50a2b7d286696e1e9a623"
    sha256 cellar: :any_skip_relocation, mojave:        "949dbf283660112a5540f412f061ec3ff08bc0a9a8649a976335fd678b6cfe0c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c33c50a33b28b155ebb50140698f5ef14e7211ac1ada0dd3e0aaafab056cde5b"
  end

  def install
    system "make", "install", "PREFIX=#{prefix}", "ENABLE_DEDUPE=1"
  end

  test do
    touch "a"
    touch "b"
    (testpath/"c").write("unique file")
    dupes = shell_output("#{bin}/jdupes --zeromatch .").strip.split("\n").sort
    assert_equal ["./a", "./b"], dupes
  end
end
