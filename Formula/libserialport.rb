class Libserialport < Formula
  desc "Cross-platform serial port C library"
  homepage "https://sigrok.org/wiki/Libserialport"
  url "https://sigrok.org/download/source/libserialport/libserialport-0.1.1.tar.gz"
  sha256 "4a2af9d9c3ff488e92fb75b4ba38b35bcf9b8a66df04773eba2a7bbf1fa7529d"
  license "LGPL-3.0"

  livecheck do
    url "https://sigrok.org/wiki/Downloads"
    regex(/href=.*?libserialport[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "98634bbc472a1c93a19a2dab32765f0f5fce4b9991988283477254f7d7b30085"
    sha256 cellar: :any,                 arm64_big_sur:  "cd674d1a466be43b3783028ca9f794d97ee5ce9c90f080cbbdb7c0479094cb26"
    sha256 cellar: :any,                 monterey:       "f9c21dc09e5a4fde3db7f3d81f976493d6da259307e05beb915dd09787ca8b62"
    sha256 cellar: :any,                 big_sur:        "67613224a8f626829329285c5dc904fb25b6dfcbf17e24e35aaeb9fbf33b0f26"
    sha256 cellar: :any,                 catalina:       "e53b9056ea9adb40aa55ec99c3a3dc1bef6cc442c1e83e0ece688b597277cebc"
    sha256 cellar: :any,                 mojave:         "abe07f2865be280c550e14a3db11cf5c99e1cd469409379f045b8280831926d6"
    sha256 cellar: :any,                 high_sierra:    "36dd828a2eba76bf82a3cd9c2c9ed9b684753c3a38aea33269f82f699762422b"
    sha256 cellar: :any,                 sierra:         "e34159ce49ba7c90e2fc0672f99df7b11a6d2de9ceccfc20679918bb87cb9b1e"
    sha256 cellar: :any,                 el_capitan:     "a2e2cb79d5a3774077c7458b0c131e67d345e8e7b2dc29735302d003fec3379e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f696db2f116fab33f25bf2b8b3b907f7b0ff3ca44e66039a5ad103e41b1d8048"
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <libserialport.h>
      int main() {
       struct sp_port *list_ptr = NULL;
       sp_get_port_by_name("some port", &list_ptr);
       return 0;
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lserialport",
                   "-o", "test"
    system "./test"
  end
end
