class GnuIndent < Formula
  desc "C code prettifier"
  homepage "https://www.gnu.org/software/indent/"
  url "https://ftp.gnu.org/gnu/indent/indent-2.2.12.tar.gz"
  mirror "https://ftpmirror.gnu.org/indent/indent-2.2.12.tar.gz"
  sha256 "e77d68c0211515459b8812118d606812e300097cfac0b4e9fb3472664263bb8b"

  bottle do
    sha256 "df1f57f1896c8b5d88d9f2e6e072dd9fc3800e2057b78879a49b67118173cad6" => :mojave
    sha256 "f8d8bd7eaa2694912f9f3cd247e252c66d21ed61a98220e768e5919f4572c022" => :high_sierra
    sha256 "6139793b451fdb8d5310729a06286ed66b23aac02d0179bfd27b61df1cc9f931" => :sierra
    sha256 "cdad0b612a3236fed1b625be2bab6500e02578ba271552e6a8a19d2cdf12df2e" => :el_capitan
    sha256 "8e19891033bc8a96894692bf0a27898112d72de5bcc78e269ba505b75b17b64f" => :yosemite
    sha256 "ff3a53ac15b4baaf030f1f1556b24a7f69788175559660ac841e039d7aee996b" => :mavericks
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
