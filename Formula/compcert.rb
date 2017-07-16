class Compcert < Formula
  desc "Formally verified C compiler"
  homepage "http://compcert.inria.fr"
  url "http://compcert.inria.fr/release/compcert-3.0.1.tgz"
  sha256 "09c7dc18c681231c6e83a963b283b66a9352a9611c9695f4b0c4b7df8c90f935"
  revision 3

  bottle do
    cellar :any_skip_relocation
    sha256 "10abf0396376729d32382adc206bd13d7f71af849cddec635fbce820c3f4e173" => :sierra
    sha256 "4c5caad496117d59d28fc017e3bd871fa0a4e76874896437dbdd0db95c85c952" => :el_capitan
    sha256 "14e895a8427d4b5720ae4d12e90406c2446cd0adfcd2046dfafb2148008c80ea" => :yosemite
  end

  option "with-config-x86_64", "Build Compcert with ./configure 'x86_64'"

  depends_on "coq" => :build
  depends_on "menhir" => :build
  depends_on "ocaml" => :build

  def install
    ENV.permit_arch_flags

    # Compcert's configure script hard-codes gcc. On Lion and under, this
    # creates problems since Xcode's gcc does not support CFI,
    # but superenv will trick it into using clang which does. This
    # causes problems with the compcert compiler at runtime.
    inreplace "configure" do |s|
      s.gsub! "${toolprefix}gcc", "${toolprefix}#{ENV.cc}"
      s.gsub! "  8.6)", "  8.6.1)"
    end

    args = ["-prefix", prefix]
    args << (build.with?("config-x86_64") ? "x86_64-macosx" : "ia32-macosx")
    system "./configure", *args
    system "make", "all"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      int printf(const char *fmt, ...);
      int main(int argc, char** argv) {
        printf("Hello, world!\\n");
        return 0;
      }
    EOS
    system bin/"ccomp", "test.c", "-o", "test"
    system "./test"
  end
end
