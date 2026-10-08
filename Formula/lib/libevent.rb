class Libevent < Formula
  desc "Asynchronous event library"
  homepage "https://libevent.org/"
  url "https://github.com/libevent/libevent/releases/download/release-2.1.13-stable/libevent-2.1.13-stable.tar.gz"
  sha256 "f7e9383b8c0baa81b687e5b5eecc01beefaf1b19b64151d95ed61647fe7a315c"
  license "BSD-3-Clause"
  revision 1
  compatibility_version 1

  livecheck do
    url :homepage
    regex(/libevent[._-]v?(\d+(?:\.\d+)+)-stable/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "45b525d77c2ecc4cf0172587e929a2bc872b1e01aabcd3679b0f60f4d76ceef7"
    sha256 cellar: :any, arm64_tahoe:       "a718c5bf998957d5c75e242ad4a0e42d86730d3321facbea282cc37cca74ff45"
    sha256 cellar: :any, arm64_sequoia:     "55344e687f9be992ae9dca23aad5bf6f3bbaa9e63031915cd2738da11787500b"
    sha256 cellar: :any, arm64_linux:       "592c7c42f355287124631461d7e51c034603526a0a6710987da73031c4604be9"
    sha256 cellar: :any, x86_64_linux:      "de71a3d6a6caa93383dc132e91dcc86c7c5a8c3e406b1485e28a8be257835818"
  end

  depends_on "pkgconf" => :build
  depends_on "openssl@4"

  def install
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
