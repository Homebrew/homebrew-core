class Libkeccak < Formula
  desc "Keccak-family hashing library"
  homepage "https://github.com/maandree/libkeccak"
  url "https://github.com/maandree/libkeccak/archive/1.1.4.tar.gz"
  sha256 "40e27983ea63faf47071402b212da48101b1dae37ce2702da947361ee8d4a313"

  depends_on "binutils" => :build
  depends_on "coreutils" => :build
  depends_on "make" => :build

  def install
    system "make", "LIBEXT=dylib", "LIBFLAGS=-dynamiclib"
    system "make", "install", "LIBEXT=dylib", "LIBFLAGS=-dynamiclib", "PREFIX=#{prefix}"
    fix_libkeccak_symlinks
  end

  def fix_libkeccak_symlinks
    mv "#{lib}/libkeccak.dylib.1.1", "#{lib}/libkeccak.1.1.dylib"
    ln_s "#{lib}/libkeccak.1.1.dylib", "#{lib}/libkeccak.1.dylib"
    rm "#{lib}/libkeccak.dylib"
    ln_s "#{lib}/libkeccak.1.1.dylib", "#{lib}/libkeccak.dylib"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <libkeccak.h>
      int main() {
      libkeccak_spec_t spec;
        libkeccak_state_t state;
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-o", "test"
    system "./test"
  end
end
