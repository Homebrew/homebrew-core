class Lesspipe < Formula
  desc "Input filter for the pager less"
  homepage "https://www-zeuthen.desy.de/~friebel/unix/lesspipe.html"
  url "https://github.com/wofr06/lesspipe/archive/1.87.tar.gz"
  sha256 "554095bc1d27514ca5480295f3f49a635bd65fd899489ab43b2a6d356258ad6c"
  license "GPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "08c1fcfdfcd4a94b7958f21bb1c4d0b9a200e9584b4be49d757fdb0087942502"
    sha256 cellar: :any_skip_relocation, big_sur:       "08c1fcfdfcd4a94b7958f21bb1c4d0b9a200e9584b4be49d757fdb0087942502"
    sha256 cellar: :any_skip_relocation, catalina:      "08c1fcfdfcd4a94b7958f21bb1c4d0b9a200e9584b4be49d757fdb0087942502"
    sha256 cellar: :any_skip_relocation, mojave:        "08c1fcfdfcd4a94b7958f21bb1c4d0b9a200e9584b4be49d757fdb0087942502"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "81a1ae192c8cbfed97adf85cb35b0f1c39fc3c58e52cf5fece5403365ede0c78"
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
    assert_match "file2.txt", shell_output("tar tvzf homebrew.tar.gz | #{bin}/tarcolor")
  end
end
