class Lesspipe < Formula
  desc "Input filter for the pager less"
  homepage "https://www-zeuthen.desy.de/~friebel/unix/lesspipe.html"
  url "https://downloads.sourceforge.net/project/lesspipe/lesspipe/1.83/lesspipe-1.83.tar.gz"
  sha256 "d616f0d51852e60fb0d0801eec9c31b10e0acc6fdfdc62ec46ef7bfd60ce675e"

  bottle do
    cellar :any_skip_relocation
    sha256 "3448d8488bccbd97cff740375ddec615718174c3e7097b9da24bb181300085e5" => :catalina
    sha256 "d4100c11c32401370733ea6a049e7016093fd51f41b1e62fca1f6cfeb70f3bf6" => :mojave
    sha256 "01c6ea7862d5b23ef49ce9c271e9cecf49c7ecd5372d9602b3ceb88b9171312b" => :high_sierra
    sha256 "f22864d81a8eb648fc4501665af743d285fcf0fa7c81edb21fd71f2593addedd" => :sierra
    sha256 "f22864d81a8eb648fc4501665af743d285fcf0fa7c81edb21fd71f2593addedd" => :el_capitan
    sha256 "f22864d81a8eb648fc4501665af743d285fcf0fa7c81edb21fd71f2593addedd" => :yosemite
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
    assert_match /file2.txt/, shell_output("tar tvzf homebrew.tar.gz | #{bin}/tarcolor")
  end
end
