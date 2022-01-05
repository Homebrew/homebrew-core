class Lesspipe < Formula
  desc "Input filter for the pager less"
  homepage "https://www-zeuthen.desy.de/~friebel/unix/lesspipe.html"
  url "https://github.com/wofr06/lesspipe/archive/v2.01.tar.gz"
  sha256 "f6642b1bda91e98c3745fe084164a556832f2aeaa9304bd7534954bff5eeceea"
  license "GPL-2.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "fb731a7ab0ab71788b7be66bbb97ca89f71d9b4a9c8d6d894aa3e616320c3547"
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
