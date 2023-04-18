class Libvterm < Formula
  desc "C99 library which implements a VT220 or xterm terminal emulator"
  homepage "http://www.leonerd.org.uk/code/libvterm/"
  url "http://www.leonerd.org.uk/code/libvterm/libvterm-0.3.1.tar.gz"
  sha256 "25a8ad9c15485368dfd0a8a9dca1aec8fea5c27da3fa74ec518d5d3787f0c397"
  license "MIT"
  version_scheme 1

  livecheck do
    url :homepage
    regex(/href=.*?libvterm[._-]v?(\d+(?:\.\d+)+)\./i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "8223c9b38657d9029e9ca4fbed618de2819a26d2c55662a2ac249ddb2e19ee20"
    sha256 cellar: :any,                 arm64_monterey: "fb4d33a68c1d2f74bf3a365b999d00699cb458470ef14473f681c28db5d862ae"
    sha256 cellar: :any,                 arm64_big_sur:  "93895eb12f869135a997949df26a6dac909061a16b5161236acc79c2a8c48de8"
    sha256 cellar: :any,                 ventura:        "047bb97a27597a58514e7cdf012064d13cf42676e1546fbe78020064ba2f88dc"
    sha256 cellar: :any,                 monterey:       "e5cb1676eea4d4a2e6aaa76d39edec5387245342811861531e747697f264aa94"
    sha256 cellar: :any,                 big_sur:        "52d39b4b5dbe5c70ff96f44ec9772b89a2218a5cc53e942ade2bf0922942d9d6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "910c60368d29ac5b99138523a0e4a03ab4c64abbe1089333ded4b481c024a1d2"
  end

  depends_on "libtool" => :build

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <vterm.h>

      int main() {
        vterm_free(vterm_new(1, 1));
      }
    EOS

    system ENV.cc, "test.c", "-L#{lib}", "-lvterm", "-o", "test"
    system "./test"
  end
end
