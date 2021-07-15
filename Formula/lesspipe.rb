class Lesspipe < Formula
  desc "Input filter for the pager less"
  homepage "https://www-zeuthen.desy.de/~friebel/unix/lesspipe.html"
  url "https://github.com/wofr06/lesspipe/archive/1.85.tar.gz"
  sha256 "cffbb432396ea4abf551bdda17adee9be3543486bc398c5c6838908e299210f9"
  license "GPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "002678f076655733319940bca3c49673aa53ef519aa3e205c48668e9aab189b1"
    sha256 cellar: :any_skip_relocation, big_sur:       "184fbb241a8dcd0e61f1564b5cdfa51deb0aff09da3cc4b4fa14163115a49de2"
    sha256 cellar: :any_skip_relocation, catalina:      "6078a8d92ebaee0b4decf8951f6ede33432f15a8e700bf5180257e38ae15a30c"
    sha256 cellar: :any_skip_relocation, mojave:        "509e6fbbdb6329be9b6405067a1c16e715c89a6d5dd0621a766e2e7b36157cdf"
    sha256 cellar: :any_skip_relocation, high_sierra:   "59920e52a34aaa64ff44c8d0cb4b157559ec767da77c86d827bd983030f42aa9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0b8ed826009991427ad509db503380680d8b8cc65b295ae252e9282f15b5c64e"
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
