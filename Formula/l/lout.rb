class Lout < Formula
  desc "Text formatting like TeX, but simpler"
  homepage "https://savannah.nongnu.org/projects/lout"
  url "https://github.com/william8000/lout/archive/refs/tags/3.43.3.tar.gz"
  sha256 "e46c086277c421953bb4a63f7d5f4b2b892db1e31d59bde9ce2a14d082abfab0"
  license "GPL-3.0-or-later"

  bottle do
    sha256 arm64_tahoe:   "a1afa5a52f5b999a4faedd548c53df1ee3d17e47f6f32031e2b056334e738a82"
    sha256 arm64_sequoia: "3c17b8b0e86ff28cb12003b6bfbb99d446b28ae0bc4aec34d1fe6a4e34b53d22"
    sha256 arm64_sonoma:  "52bfa6645aeb972c156d84e136ff9fc6087afb403ac2cf5a50d886e7821409ed"
    sha256 sonoma:        "4962fe83929db8cfa8e540db1895aa4af1fc15332aace87eb4349446d872fd3d"
    sha256 arm64_linux:   "47228ee2a75ab6708d6223724920b60c530d321e5cd7da70d237aea3bf909730"
    sha256 x86_64_linux:  "d1e920405f03ab021f8b7f4a00cb04891e7d60791255349a3e91921ad89ac35c"
  end

  def install
    bin.mkpath
    man1.mkpath
    (doc/"lout").mkpath
    system "make", "PREFIX=#{prefix}", "LOUTLIBDIR=#{lib}", "LOUTDOCDIR=#{doc}", "MANDIR=#{man}", "allinstall"
  end

  test do
    input = "test.lout"
    (testpath/input).write <<~EOS
      @SysInclude { doc }
      @Doc @Text @Begin
      @Display @Heading { Blindtext }
      The quick brown fox jumps over the lazy dog.
      @End @Text
    EOS
    assert_match(/^\s+Blindtext\s+The quick brown fox.*\n+$/, shell_output("#{bin}/lout -p #{input}"))
  end
end
