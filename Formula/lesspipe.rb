class Lesspipe < Formula
  desc "Input filter for the pager less"
  homepage "https://www-zeuthen.desy.de/~friebel/unix/lesspipe.html"
  url "https://github.com/wofr06/lesspipe/archive/1.90.tar.gz"
  sha256 "db1a02e41654d7f842e9a88b9a3439384a023e25e968239897bac471f5f23489"
  license "GPL-2.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "e1e2e8c6dfa12655279bc3a6d8869a71727f6fbc014796f9970f4b99bec879bc"
    sha256 cellar: :any_skip_relocation, big_sur:       "e1e2e8c6dfa12655279bc3a6d8869a71727f6fbc014796f9970f4b99bec879bc"
    sha256 cellar: :any_skip_relocation, catalina:      "e1e2e8c6dfa12655279bc3a6d8869a71727f6fbc014796f9970f4b99bec879bc"
    sha256 cellar: :any_skip_relocation, mojave:        "e1e2e8c6dfa12655279bc3a6d8869a71727f6fbc014796f9970f4b99bec879bc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a0ae934aea25951e3b5903b5bfbc3698e296d7ca7b30ed492b69aa7b1486f2a4"
    sha256 cellar: :any_skip_relocation, all:           "e1e2e8c6dfa12655279bc3a6d8869a71727f6fbc014796f9970f4b99bec879bc"
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
