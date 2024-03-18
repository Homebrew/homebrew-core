class Lesspipe < Formula
  desc "Input filter for the pager less"
  homepage "https://www-zeuthen.desy.de/~friebel/unix/lesspipe.html"
  url "https://github.com/wofr06/lesspipe/archive/refs/tags/v2.12.tar.gz"
  sha256 "81c907dbb71063e4e76893b7d24893e094e6b323e7dbccf45c68c26a18ca2fe3"
  license "GPL-2.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9ff0fe23926dc0e7bdb4aa7b9ba15ae4526a34408485a6961dff10e28c851441"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9ff0fe23926dc0e7bdb4aa7b9ba15ae4526a34408485a6961dff10e28c851441"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9ff0fe23926dc0e7bdb4aa7b9ba15ae4526a34408485a6961dff10e28c851441"
    sha256 cellar: :any_skip_relocation, sonoma:         "9ff0fe23926dc0e7bdb4aa7b9ba15ae4526a34408485a6961dff10e28c851441"
    sha256 cellar: :any_skip_relocation, ventura:        "9ff0fe23926dc0e7bdb4aa7b9ba15ae4526a34408485a6961dff10e28c851441"
    sha256 cellar: :any_skip_relocation, monterey:       "9ff0fe23926dc0e7bdb4aa7b9ba15ae4526a34408485a6961dff10e28c851441"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cd1aa232c8507c9ab1e20628bc7f51cbe7e653c8921e078c04141acb1659c78a"
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    man1.mkpath
    system "make", "install"
  end

  def caveats
    <<~EOS
      add the following to your shell profile e.g. ~/.profile or ~/.zshrc:
        export LESSOPEN="|#{HOMEBREW_PREFIX}/bin/lesspipe.sh %s"
    EOS
  end

  test do
    touch "file1.txt"
    touch "file2.txt"
    system "tar", "-cvzf", "homebrew.tar.gz", "file1.txt", "file2.txt"

    assert_predicate testpath/"homebrew.tar.gz", :exist?
    assert_match "file2.txt", pipe_output(bin/"archive_color", shell_output("tar -tvzf homebrew.tar.gz"))
  end
end
