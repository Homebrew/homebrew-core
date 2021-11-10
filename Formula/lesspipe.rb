class Lesspipe < Formula
  desc "Input filter for the pager less"
  homepage "https://www-zeuthen.desy.de/~friebel/unix/lesspipe.html"
  url "https://github.com/wofr06/lesspipe/archive/1.90.tar.gz"
  sha256 "db1a02e41654d7f842e9a88b9a3439384a023e25e968239897bac471f5f23489"
  license "GPL-2.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5d0298b0f684df89c4b309e65a275a1c00092a36fdedf8fa0322994789ce1537"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5d0298b0f684df89c4b309e65a275a1c00092a36fdedf8fa0322994789ce1537"
    sha256 cellar: :any_skip_relocation, monterey:       "5d0298b0f684df89c4b309e65a275a1c00092a36fdedf8fa0322994789ce1537"
    sha256 cellar: :any_skip_relocation, big_sur:        "5d0298b0f684df89c4b309e65a275a1c00092a36fdedf8fa0322994789ce1537"
    sha256 cellar: :any_skip_relocation, catalina:       "5d0298b0f684df89c4b309e65a275a1c00092a36fdedf8fa0322994789ce1537"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b03d0989b4ab81bb0a361a1874535449545efd1b34972a2677dc6698dd08f2b0"
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
