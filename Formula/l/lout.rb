class Lout < Formula
  desc "Text formatting like TeX, but simpler"
  homepage "https://savannah.nongnu.org/projects/lout"
  url "https://github.com/william8000/lout/archive/refs/tags/3.43.tar.gz"
  sha256 "b95f1d0d75f31d3a59fd9ab6d15901e49155b94f000b5798b45c47b63eac6407"
  license "GPL-3.0-or-later"

  bottle do
    sha256 arm64_sequoia:  "ca58a4f9c17d8f1945c7463ae5b3c40649978d19edb6ed00f7313d2e0f2e4669"
    sha256 arm64_sonoma:   "46be9ac6c081f6757dd0501b7cf6edda88724f37e1765f43db1529f952d85cc2"
    sha256 arm64_ventura:  "c216a68f6acb79b202cd49b4f47d6a01d48d8d18adcf5ffb7c075f8b52622890"
    sha256 arm64_monterey: "893a8a4cb6d07e906cc61b37a4448284b3166d31389dfbf9021c5ed9a449afd3"
    sha256 sonoma:         "6bfe5d76715131438b0db2b129c818862f76f9da5d16492c1a679e9b2dd42155"
    sha256 ventura:        "d8d51b0edbdc2a09a78d3bbb6ba6a0e55d79e9a8768071aa380638f05a83f2a8"
    sha256 monterey:       "174686a36deeacde11aa8296d80968fa66e09a19d3f8cc3ac20b31fd69392487"
    sha256 x86_64_linux:   "ae6f004e3bb16e2a669f59c9d6f5e656e047592af4f9f95a791e2df77cd64c59"
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
