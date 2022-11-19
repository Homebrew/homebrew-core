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
    sha256 cellar: :any,                 arm64_ventura:  "cced4a6f6a38cabd05d51941acc1ec04110375e4900147c40e865284f2f5dca0"
    sha256 cellar: :any,                 arm64_monterey: "63203f653864f3d95320946e141b562087c2efebb5a0c78776a6715157ff79df"
    sha256 cellar: :any,                 arm64_big_sur:  "9bd568c95d44276b460b9b9f42df93276093388885770a8d635592bb068602f7"
    sha256 cellar: :any,                 monterey:       "064c5b6a8793964950a51ebaa22711c2aa092c5f285499325c7c1d725a617c8c"
    sha256 cellar: :any,                 big_sur:        "63a54c90684fd19105629ec224096e6d8b5b0b29305598a418de2dc7ea3a34d2"
    sha256 cellar: :any,                 catalina:       "baa8fafc0b418c402f497559c32f4181a72ff86fe6713c13d3e740b2bbe29327"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "91fb815d3495b95770615b23075c3b628e96758815c490ef851dc2191396fcc9"
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
