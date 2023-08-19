class Nopoll < Formula
  desc "Open-source C WebSocket toolkit"
  homepage "https://www.aspl.es/nopoll/"
  url "https://www.aspl.es/nopoll/downloads/nopoll-0.4.8.b429.tar.gz"
  version "0.4.8.b429"
  sha256 "4031f2afd57dbcdb614dd3933845be7fcf92a85465b6228daab3978dc5633678"
  license "LGPL-2.1-or-later"

  livecheck do
    url "https://www.aspl.es/nopoll/downloads/"
    regex(/href=.*?nopoll[._-]v?(\d+(?:\.\d+)+(?:\.b\d+)?)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "506b43f4c6599606a2d963ebc96fbb6fe0d513227a241bdf2be7645dce62fb62"
    sha256 cellar: :any,                 arm64_monterey: "67fa34a544afa84b26e296f7c5614eb4f5d676f907a83048ee5912d256d80e9a"
    sha256 cellar: :any,                 arm64_big_sur:  "549c85f59b6565f42734f55c461ddf7c6d6d5a501456d99bbae0baae769bc258"
    sha256 cellar: :any,                 ventura:        "6f6519530b264e20b7f569d15a409d000fa1aa1eddaf0d8c148e08b0a9bb2066"
    sha256 cellar: :any,                 monterey:       "9ef66c711085d89346b8982c3f637aa6d97b8bfcb82fc3a69112c980c435b930"
    sha256 cellar: :any,                 big_sur:        "786ad31fb592a5d8c9ea666714417e157833a68d639061466b283e744b06ce93"
    sha256 cellar: :any,                 catalina:       "963a65db0b4c29a2c00e434b405d4dabc766b9179d4cd3765493af5f72668625"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "34cef30326e6770bf5ed11ee2a1788f5ec7cee86ce39c36cfcf419909073b337"
  end

  depends_on "openssl@3"

  def install
    system "./configure", *std_configure_args, "--disable-silent-rules"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <nopoll.h>
      int main(void) {
        noPollCtx *ctx = nopoll_ctx_new();
        nopoll_ctx_unref(ctx);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}/nopoll", "-L#{lib}", "-lnopoll",
           "-o", "test"
    system "./test"
  end
end
