class Compcert < Formula
  desc "Formally verified C compiler"
  homepage "http://compcert.inria.fr"
  url "https://github.com/AbsInt/CompCert/archive/v3.2.tar.gz"
  sha256 "23b1a9585e6e9fa211dccae40fc9053c75e7f5519e4b698751bb67a083080487"

  bottle do
    cellar :any_skip_relocation
    sha256 "365f0f9df5be211dd090d112d659fbcc01b0dc145f2ec493e17301aa8c3b471b" => :high_sierra
    sha256 "af8952aa293ca948c04646eaadbf4acbc1c606686e244b1eff47fca447f7bab8" => :sierra
    sha256 "3a5d5d6de9c4ca77739dd44776e664f4b551524a285036343aa6d5b39d1b7571" => :el_capitan
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
    inreplace "configure", "${toolprefix}gcc", "${toolprefix}#{ENV.cc}"

    args = ["-prefix", prefix]
    args << (build.with?("config-x86_64") ? "x86_64-macosx" : "ia32-macosx")
    system "./configure", *args
    system "make", "all"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
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
