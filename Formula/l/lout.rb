class Lout < Formula
  desc "Text formatting like TeX, but simpler"
  homepage "https://savannah.nongnu.org/projects/lout"
  url "https://github.com/william8000/lout/archive/refs/tags/3.43.5.tar.gz"
  sha256 "4fad5c0a23d42e05e127fa236b1bd60693829d61d98dcf2bec5d80b1a212bdaf"
  license "GPL-3.0-or-later"

  bottle do
    sha256 arm64_golden_gate: "a90921901e3a5630133c727943b19f8143a6752aff153c630dfbd1de14169d2e"
    sha256 arm64_tahoe:       "b7af67416857be3856f6cd8257ceb82d5668f54c2489f06674d160282ffbaee1"
    sha256 arm64_sequoia:     "665f45abfea4ae42da28e05992734db9151094b20a834a1a908d6ff192886fbc"
    sha256 arm64_linux:       "c71425ce3c6d3a0167e8033fe6b8998da0e438a17797801da5610b097a3391cf"
    sha256 x86_64_linux:      "84f904b29fde26f1b1b7f19f4a30070adad9bd3036b1ec820b04af25814895cc"
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
