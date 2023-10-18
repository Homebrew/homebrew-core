class Libedit < Formula
  desc "BSD-style licensed readline alternative"
  homepage "https://thrysoee.dk/editline/"
  url "https://thrysoee.dk/editline/libedit-20230828-3.1.tar.gz"
  version "20230828-3.1"
  sha256 "4ee8182b6e569290e7d1f44f0f78dac8716b35f656b76528f699c69c98814dad"
  license "BSD-3-Clause"

  livecheck do
    url :homepage
    regex(/href=.*?libedit[._-]v?(\d{4,}-\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "b085923141c20b3f01791a17c230d01817fa0247d8a8f51d6461f015c539b601"
    sha256 cellar: :any,                 arm64_ventura:  "7df8b6d1eefb735eb019a81af48c41f9339589c27f8bf44f6194eb47f47d34c0"
    sha256 cellar: :any,                 arm64_monterey: "735f2b5d2826f5cae4b1e49a2a2c7473574d0d6e4b45a6be41173c34ae2597f4"
    sha256 cellar: :any,                 arm64_big_sur:  "f8c49eadade2fa70ba2dee19e3c1251c40c0ba7e2b57d18990452cb6f5135a83"
    sha256 cellar: :any,                 sonoma:         "c8fd317bac4ca00fcbb2eecd0446c9aa917247e6eb15f57f0bb2d2a4594c90b0"
    sha256 cellar: :any,                 ventura:        "079e6825a76aee062a23925e879b784e21abb848be6c7c186d7390e8e1b2aa33"
    sha256 cellar: :any,                 monterey:       "70e1ce85fcbb9c41bc81e3ffedf78c8b50873baff65a5dc30e0fb06d8b2d0bd2"
    sha256 cellar: :any,                 big_sur:        "2c4af92251b1776773bf207a926aebf42bc240d32337f29d62dd9587307d0072"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5cb9c8007d6d9b21cc81c5bcd92e50ee75bc9605a0a2014399c31c720a92edcd"
  end

  keg_only :provided_by_macos

  uses_from_macos "ncurses"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"

    if OS.linux?
      # Conflicts with readline.
      mv man3/"history.3", man3/"history_libedit.3"
    end
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      #include <histedit.h>
      int main(int argc, char *argv[]) {
        EditLine *el = el_init(argv[0], stdin, stdout, stderr);
        return (el == NULL);
      }
    EOS
    system ENV.cc, "test.c", "-o", "test", "-L#{lib}", "-ledit", "-I#{include}"
    system "./test"
  end
end
