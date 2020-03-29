class Lesspipe < Formula
  desc "Input filter for the pager less"
  homepage "https://www-zeuthen.desy.de/~friebel/unix/lesspipe.html"
  url "https://github.com/wofr06/lesspipe/archive/1.84.tar.gz"
  sha256 "5eb4811cc8ded108e98448bd83057e730906f643ad689ccd695828f2a46c4410"

  bottle do
    cellar :any_skip_relocation
    sha256 "ddefc7bc6202699c00fc69d5bf4e22c06a05cc6ad7c49dca5ff84c32b88ad190" => :catalina
    sha256 "ddefc7bc6202699c00fc69d5bf4e22c06a05cc6ad7c49dca5ff84c32b88ad190" => :mojave
    sha256 "ddefc7bc6202699c00fc69d5bf4e22c06a05cc6ad7c49dca5ff84c32b88ad190" => :high_sierra
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
