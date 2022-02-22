class Lesspipe < Formula
  desc "Input filter for the pager less"
  homepage "https://www-zeuthen.desy.de/~friebel/unix/lesspipe.html"
  url "https://github.com/wofr06/lesspipe/archive/v2.03.tar.gz"
  sha256 "5f2c7e35da2d3ea05fbc6d973e802abc0c5312bde3eba9b9f502022b72ddf45d"
  license "GPL-2.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "a48bb2c497472436170a08b5ee627c248407b8382b3e151b5dfdb173d3181ba8"
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
