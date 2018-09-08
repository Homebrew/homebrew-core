class GnuIndent < Formula
  desc "C code prettifier"
  homepage "https://www.gnu.org/software/indent/"
  url "https://ftp.gnu.org/gnu/indent/indent-2.2.12.tar.gz"
  mirror "https://ftpmirror.gnu.org/indent/indent-2.2.12.tar.gz"
  sha256 "e77d68c0211515459b8812118d606812e300097cfac0b4e9fb3472664263bb8b"

  bottle do
    sha256 "d2273d950e095a6a5ae131cb51c7ba62ed6f2bda565551f46c9518182c31cd34" => :mojave
    sha256 "6d603a5f968605c2ed9af1ff18d6b76eed05d49836ff26358b01be6b740654e0" => :high_sierra
    sha256 "07577059357f159117de4b92172c4241f276efbc42ae1bf0faf818288e9e59b4" => :sierra
    sha256 "516664bba21882339cedbb539ee3ac5a262d5929c4472de1b935a4b9a4737db8" => :el_capitan
  end

  option "with-default-names", "Do not prepend 'g' to the binary"

  depends_on "gettext"

  deprecated_option "default-names" => "with-default-names"

  def install
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
      --mandir=#{man}
    ]

    args << "--program-prefix=g" if build.without? "default-names"

    system "./configure", *args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write("int main(){ return 0; }")
    system "#{bin}/gindent", "test.c"
    assert_equal File.read("test.c"), <<~EOS
      int
      main ()
      {
        return 0;
      }
    EOS
  end
end
