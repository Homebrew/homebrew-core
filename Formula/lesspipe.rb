class Lesspipe < Formula
  desc "Input filter for the pager less"
  homepage "https://www-zeuthen.desy.de/~friebel/unix/lesspipe.html"
  url "https://github.com/wofr06/lesspipe/archive/v2.01.tar.gz"
  sha256 "f6642b1bda91e98c3745fe084164a556832f2aeaa9304bd7534954bff5eeceea"
  license "GPL-2.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "6330ca5233a6d4dc5426377b9d6609e16f948400d58294c26d0071750cf94a7b"
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
