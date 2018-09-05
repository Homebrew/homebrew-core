class Compcert < Formula
  desc "Formally verified C compiler"
  homepage "http://compcert.inria.fr"
  url "https://github.com/AbsInt/CompCert/archive/v3.3.tar.gz"
  sha256 "9677806d7fef5651dd23e39f7bb26e6aecbe7d70d2f466cb746187a938c3b99b"

  bottle do
    cellar :any_skip_relocation
    sha256 "0253060570372efb386b38514d1df0377e0ed81f293ad7204d8c540d7e6ad02a" => :high_sierra
    sha256 "b3fa1029e71733d2181a47198a143dc85ce0bc470b864b86dd9f47746e3284db" => :sierra
    sha256 "93636c31e770c928d59079a5e7dc8845ad226452b7a35852d80d942fc30dd9e7" => :el_capitan
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
