class Compcert < Formula
  desc "Formally verified C compiler"
  homepage "http://compcert.inria.fr"
  url "http://compcert.inria.fr/release/compcert-3.0.1.tgz"
  sha256 "09c7dc18c681231c6e83a963b283b66a9352a9611c9695f4b0c4b7df8c90f935"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "8c5306716040478221d6bceb6d4b01e7bee04bcb33b0b1242b8b73eb887634c5" => :sierra
    sha256 "a1feea71910e24d885753b22505185a45c97262b63fef65c20a7a4b58e28d128" => :el_capitan
    sha256 "017b63dd93c64946977153b5c8e52e30ada1c3e79795498ba3c68ff0b040da8e" => :yosemite
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
