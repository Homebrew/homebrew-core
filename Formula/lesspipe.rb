class Lesspipe < Formula
  desc "Input filter for the pager less"
  homepage "https://www-zeuthen.desy.de/~friebel/unix/lesspipe.html"
  url "https://github.com/wofr06/lesspipe/archive/1.91.tar.gz"
  sha256 "6192e7e451c5db26841c6dc3cbcc23c1ef396c1cc4588288effa699dbc665cdb"
  license "GPL-2.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "eab2efbe871e0533c2610a0eb643f079e6dfadde5566aa8882a9c60b263d5882"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "eab2efbe871e0533c2610a0eb643f079e6dfadde5566aa8882a9c60b263d5882"
    sha256 cellar: :any_skip_relocation, monterey:       "eab2efbe871e0533c2610a0eb643f079e6dfadde5566aa8882a9c60b263d5882"
    sha256 cellar: :any_skip_relocation, big_sur:        "eab2efbe871e0533c2610a0eb643f079e6dfadde5566aa8882a9c60b263d5882"
    sha256 cellar: :any_skip_relocation, catalina:       "eab2efbe871e0533c2610a0eb643f079e6dfadde5566aa8882a9c60b263d5882"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8db1eb487dcae19e75c6926212c274b62d04438193ccbe61e00a5bcb7ccba571"
  end

  def install
    system "./configure", "--prefix=#{prefix}", "--yes"
    man1.mkpath
    system "make", "install"
  end

  def caveats
    <<~EOS
      Append the following to your #{shell_profile}:
      export LESSOPEN="|#{HOMEBREW_PREFIX}/bin/lesspipe.sh %s" LESS_ADVANCED_PREPROCESSOR=1
    EOS
  end

  test do
    touch "file1.txt"
    touch "file2.txt"
    system "tar", "-cvzf", "homebrew.tar.gz", "file1.txt", "file2.txt"

    assert_predicate testpath/"homebrew.tar.gz", :exist?
    assert_match "file2.txt", pipe_output(bin/"tarcolor", shell_output("tar -tvzf homebrew.tar.gz"))
  end
end
