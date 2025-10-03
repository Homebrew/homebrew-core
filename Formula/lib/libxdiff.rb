class Libxdiff < Formula
  desc "Implements diff functions for binary and text files"
  homepage "http://www.xmailserver.org/xdiff-lib.html"
  url "http://www.xmailserver.org/libxdiff-0.23.tar.gz"
  sha256 "e9af96174e83c02b13d452a4827bdf47cb579eafd580953a8cd2c98900309124"
  license "LGPL-2.1-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?libxdiff[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:    "52f89bab5540ae76ddffb01090a41adc4ca1f11696aa0f64274307b1fc84bfcc"
    sha256 cellar: :any,                 arm64_sequoia:  "044f8ca7045a788d7096478af46442537dd601d92b6d73c8808f6c2337d0990c"
    sha256 cellar: :any,                 arm64_sonoma:   "ed60064f8f7f516a9b4d240ed4c7b585867c9da39cdcb22560a4ece5e8660509"
    sha256 cellar: :any,                 arm64_ventura:  "2eac99be7b74fae52532e808461ec21675681d64e25ece6e99b54176a20618ab"
    sha256 cellar: :any,                 arm64_monterey: "418d1252e31f6107429fd06539f95a4bede475d382ef351ff311fc577ef05fc0"
    sha256 cellar: :any,                 arm64_big_sur:  "f986d3e17b2ca9bf61f85fb8dffe837edbd5bee22b1c21c27f3ecfea9a83b12b"
    sha256 cellar: :any,                 sonoma:         "2eda8f1a3b63b3d382995b0fad6f3f34b43833c31ff38068a1cd1ce43b12c097"
    sha256 cellar: :any,                 ventura:        "61714ffb05a6444a400caf45d75d6013348f961853020e6b662045fecfa23283"
    sha256 cellar: :any,                 monterey:       "9864ce81b41b379e60946847ae1dc20f2a8f8296622581335842884d7bfacaaf"
    sha256 cellar: :any,                 big_sur:        "bb4777447c50173e1edd3a65eb75559a4ec8f14621f01cdc40b639b86e206162"
    sha256 cellar: :any,                 catalina:       "bb5dedb22ce363d4c6b8f46d3059dc81d68ba3627aaaff8efcdaa6c6b2c2ea37"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "145ff279df6f6dc46924f9a8182d89c1e568156f29f711efef540649e653d90d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f7b3220efc3c97fefbe4ec212663fe86de66179d36fb974377790d72ebd5ed41"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  def install
    system "autoreconf", "--force", "--verbose", "--install"
    system "./configure", "--mandir=#{man}", *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <xdiff.h>
      int main(void) {
        return 0;
      }
    C

    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lxdiff", "-o", "test"
    system "./test"
  end
end
