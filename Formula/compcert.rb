class Compcert < Formula
  desc "Formally verified C compiler"
  homepage "http://compcert.inria.fr"
  url "https://github.com/AbsInt/CompCert/archive/v3.1.tar.gz"
  sha256 "9d0dd07f05a9a59b865041417dc61f16a664d85415f0271eb854412638e52e47"

  bottle do
    cellar :any_skip_relocation
    sha256 "9a5256529b943edaa4d0d613d0dfed827df8ebb1f4de9fbd67e1cceb2d7d218f" => :high_sierra
    sha256 "02d892ec34b7c991629d747b822a0f75c5e9a790113886ac4925c2df67bbcce9" => :sierra
    sha256 "ae065d7a0008a20c42277b33166e1197931d64af120ae2dc06ff96425bf96e30" => :el_capitan
    sha256 "895f0814f70ddc41a07496f6f99c865d132bca38654d9c44581c2a89e828dc9b" => :yosemite
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
