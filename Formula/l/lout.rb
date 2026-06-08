class Lout < Formula
  desc "Text formatting like TeX, but simpler"
  homepage "https://savannah.nongnu.org/projects/lout"
  url "https://github.com/william8000/lout/archive/refs/tags/3.43.4.tar.gz"
  sha256 "5cc2700f842860dd4d0af95ef5aff8cf9fe1e155d04ee951f790697aa27e7807"
  license "GPL-3.0-or-later"

  bottle do
    sha256 arm64_tahoe:   "b8d0ee5097c542dd495701a5b383a6cabe1e08cc49ce2144c9e20c4ed372590d"
    sha256 arm64_sequoia: "4bc74cb1822bfcb333c7741cfe52876c2ef3bd46e1fff4ce2d43fef63df5df60"
    sha256 arm64_sonoma:  "48458dd5194f830f27ad18b48900c733ffdcfb90343fe110c9deb6a6d439c2a5"
    sha256 sonoma:        "96518ac2aa54a68e3c4286a4b3e94f77ec4c1c4502466d4e2f6e8e10a0b0306b"
    sha256 arm64_linux:   "bd5da0dd25b268c804630d677692757518472af004fd5e412b648ec03e4674a1"
    sha256 x86_64_linux:  "3615a978686e8e6f48f041c6b7e8190d669b89978b809ee3b3ac82a233609dbb"
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
