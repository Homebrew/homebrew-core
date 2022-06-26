class Nopoll < Formula
  desc "Open-source C WebSocket toolkit"
  homepage "https://www.aspl.es/nopoll/"
  url "https://www.aspl.es/nopoll/downloads/nopoll-0.4.7.b429.tar.gz"
  version "0.4.7.b429"
  sha256 "d5c020fec25e3fa486c308249833d06bed0d76bde9a72fd5d73cfb057c320366"
  license "LGPL-2.1-or-later"

  livecheck do
    url "https://www.aspl.es/nopoll/downloads/"
    regex(/href=.*?nopoll[._-]v?(\d+(?:\.\d+)+(?:\.b\d+)?)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "c430aa6bc3ce0eaf8b470cfaa7bd4f38dae90982ba24484f2c85d8ad803706f5"
    sha256 cellar: :any,                 arm64_big_sur:  "56ca477a877be4c8fd8ad870f5a3b026e683b45e72b2d46446c9253ed4d458b1"
    sha256 cellar: :any,                 monterey:       "7a66b289344d2489ef37a1781200cf563fa6a689d550b68197988d771ef9150b"
    sha256 cellar: :any,                 big_sur:        "fa5ab01cd0a602131ef14964775eabfc6307b9f10fd98b4a92b18c32ea4d9cb5"
    sha256 cellar: :any,                 catalina:       "53d32b361a7e9a2e7b5c6a302483145130a338e2348b9da0193375d2ccb4b049"
    sha256 cellar: :any,                 mojave:         "ee81d7f293699e3a2cb8a5587d362c2236b321f291841718cc93c54fe0ccd19f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "abbd47332ae6aa89803c11bff2f625ccaac60805dc200af683592d7d0dd3eef9"
  end

  depends_on "openssl@1.1"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
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
