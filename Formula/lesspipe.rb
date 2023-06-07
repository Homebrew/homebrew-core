class Lesspipe < Formula
  desc "Input filter for the pager less"
  homepage "https://www-zeuthen.desy.de/~friebel/unix/lesspipe.html"
  url "https://github.com/wofr06/lesspipe/archive/v2.07.tar.gz"
  sha256 "b6a591c053057c3968d0d1fbd32e4a0a8026cd5c27e861023e3542772eda1cba"
  license "GPL-2.0-only"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c2156478a5b6006415e8d51dfaa6eef48f4f9b65a2166c8a3deace997809e3b2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c2156478a5b6006415e8d51dfaa6eef48f4f9b65a2166c8a3deace997809e3b2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c2156478a5b6006415e8d51dfaa6eef48f4f9b65a2166c8a3deace997809e3b2"
    sha256 cellar: :any_skip_relocation, ventura:        "c2156478a5b6006415e8d51dfaa6eef48f4f9b65a2166c8a3deace997809e3b2"
    sha256 cellar: :any_skip_relocation, monterey:       "c2156478a5b6006415e8d51dfaa6eef48f4f9b65a2166c8a3deace997809e3b2"
    sha256 cellar: :any_skip_relocation, big_sur:        "c2156478a5b6006415e8d51dfaa6eef48f4f9b65a2166c8a3deace997809e3b2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ceb4e96042a617340ea075043fa7baa75056229a80270f9dcb9f0e4f411415df"
  end

  # patch for runtime error, remove in next release
  patch do
    url "https://github.com/wofr06/lesspipe/commit/ff6ecf9671a417ee85218a99c47a93ce2c0388be.patch?full_index=1"
    sha256 "4204136f2e1ad0fa8a9b1f42b192ce422799860d073663130e77eefa107260ca"
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
