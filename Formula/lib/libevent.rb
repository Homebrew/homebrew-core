class Libevent < Formula
  desc "Asynchronous event library"
  homepage "https://libevent.org/"
  url "https://github.com/libevent/libevent/archive/refs/tags/release-2.1.12-stable.tar.gz"
  sha256 "7180a979aaa7000e1264da484f712d403fcf7679b1e9212c4e3d09f5c93efc24"
  license "BSD-3-Clause"
  revision 2
  compatibility_version 1

  livecheck do
    url :homepage
    regex(/libevent[._-]v?(\d+(?:\.\d+)+)-stable/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "12e6b088b3636a24573d91eaa2f6a6bfbe7fafc3bb50e779954d1afee3cd220d"
    sha256 cellar: :any,                 arm64_sequoia: "439f517244b007ffe7fa78f73397462acf27d32cd0d569d354cbc07caf2f29fe"
    sha256 cellar: :any,                 arm64_sonoma:  "b771c9a3b605191b37eb567e68dbb127797b1f049d0707b01517f57bcdf704b9"
    sha256 cellar: :any,                 sonoma:        "0d0a088b74c2200290b688959dbd1db4aaf7f88d405c296a019f4cb9b265657e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8df54de5285f5b884e43a3befcd10d9a63568886493a6e0a58f5af70ec7ed508"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5432edb3ce2cc87adac40896e471d305d21474cdbbd149bdc6d3c5222ee3e20c"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build
  depends_on "openssl@4"

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
