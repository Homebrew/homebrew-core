class Lesspipe < Formula
  desc "Input filter for the pager less"
  homepage "https://www-zeuthen.desy.de/~friebel/unix/lesspipe.html"
  url "https://github.com/wofr06/lesspipe/archive/1.85.tar.gz"
  sha256 "cffbb432396ea4abf551bdda17adee9be3543486bc398c5c6838908e299210f9"
  license "GPL-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "6078a8d92ebaee0b4decf8951f6ede33432f15a8e700bf5180257e38ae15a30c" => :catalina
    sha256 "509e6fbbdb6329be9b6405067a1c16e715c89a6d5dd0621a766e2e7b36157cdf" => :mojave
    sha256 "59920e52a34aaa64ff44c8d0cb4b157559ec767da77c86d827bd983030f42aa9" => :high_sierra
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
