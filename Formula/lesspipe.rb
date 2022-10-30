class Lesspipe < Formula
  desc "Input filter for the pager less"
  homepage "https://www-zeuthen.desy.de/~friebel/unix/lesspipe.html"
  url "https://github.com/wofr06/lesspipe/archive/v2.06.tar.gz"
  sha256 "f46c7b0b06f951613535a480d22ba7e8563f4f08d3d3f8e370047df122cb1637"
  license "GPL-2.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "1fea365d12621bd65e1df169e2355b4d91ab157081ca83bb8c9346ae799f5669"
  end

  # build patch, remove in next release
  patch do
    url "https://github.com/wofr06/lesspipe/commit/8ebede2ee629fa7154dcb854d50b325ef9c54163.patch?full_index=1"
    sha256 "a39ecba93b829d055973773746dd1447e38487169d89bb7161322066799c1534"
  end

  def install
    system "./configure", "--prefix=#{prefix}", "--yes"
    man1.mkpath
    system "make", "install"
  end

  def caveats
    <<~EOS
      Append the following to your #{shell_profile}:
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
