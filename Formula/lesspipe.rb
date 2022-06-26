class Lesspipe < Formula
  desc "Input filter for the pager less"
  homepage "https://www-zeuthen.desy.de/~friebel/unix/lesspipe.html"
  url "https://github.com/wofr06/lesspipe/archive/v2.05.tar.gz"
  sha256 "78eab63d8bcb07ab9e2230bc4627ffa7b1c9296f0091b1237f52daf7f1d4682f"
  license "GPL-2.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "89c5065b6535158e2d9951266ec936cad15025ddcaa712e4f4ea597b9ea37763"
  end

  def install
    inreplace "configure", "/etc/bash_completion.d", bash_completion
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
