class Libevent < Formula
  desc "Asynchronous event library"
  homepage "https://libevent.org/"
  url "https://github.com/libevent/libevent/archive/refs/tags/release-2.1.13-stable.tar.gz"
  sha256 "1a0885e17dc78afbaeddf13cf849f9238bbc24acdc178464a0d1934d7c5ffbd5"
  license "BSD-3-Clause"
  compatibility_version 1

  livecheck do
    url :homepage
    regex(/libevent[._-]v?(\d+(?:\.\d+)+)-stable/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "a89bc8b73301ea34ef28dfe355d8ef6a068250184e216a66b98f60435ecfb372"
    sha256 cellar: :any, arm64_sequoia: "fd79042d1b524a34e00ef2c04ab71069f4105c1cf3aaa2407c0d608736c4ad1a"
    sha256 cellar: :any, arm64_sonoma:  "d9bd12ae21a16634bba8ca8c9dca13e36c9fa783f5907e789a93a95e75a91b3e"
    sha256 cellar: :any, sonoma:        "9a84f598bdd5283e794ee467ce1e8505df47930d0c101309f7329944db743d96"
    sha256 cellar: :any, arm64_linux:   "da39ded40a1d60992d16fa256185ce6bc84039a5cdd2ab31139262755326e94c"
    sha256 cellar: :any, x86_64_linux:  "2d1db7d19f8ffe0791977488d3442d98cd334c9f38b91b11b0e19ab8d4170e01"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build
  depends_on "openssl@3"

  def install
    system "./autogen.sh"
    system "./configure", "--disable-debug-mode", *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <event2/event.h>

      int main()
      {
        struct event_base *base;
        base = event_base_new();
        event_base_free(base);
        return 0;
      }
    C
    system ENV.cc, "test.c", "-L#{lib}", "-levent", "-o", "test"
    system "./test"
  end
end
