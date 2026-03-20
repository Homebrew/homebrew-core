class Libstrophe < Formula
  desc "XMPP library for C"
  homepage "https://strophe.im/libstrophe/"
  url "https://github.com/strophe/libstrophe/archive/refs/tags/0.14.0.tar.gz"
  sha256 "adeb9e673d7f8b8cd20a2437cc220a8de581abf6e46594896b622e3e0dfa5c1f"
  license all_of: ["GPL-3.0-only", "MIT"]
  head "https://github.com/strophe/libstrophe.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "452f93fb9065a6120f12edd141f2c587e1d825714ff33e15408aae7e5ced9474"
    sha256 cellar: :any,                 arm64_sequoia: "5aaeb0aaa4d7af57d2dcf868e79ab429267a48220806a0623db471ef726d3846"
    sha256 cellar: :any,                 arm64_sonoma:  "1ef2a0bcec6bcb9f5fc25646e3a209afd36b26a4c41429b295915d5cf21837ff"
    sha256 cellar: :any,                 sonoma:        "1979d7003784e3fb42e13fa456e19bd917f53326336c098f4ab9749ab4ead761"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e53cffafb102848cc089db78fbd6d9d2d7e7bd6fe178722565e7088de5efa679"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "23e1b9e04065508e411e4590f98e1c0a5b23c51fc183bb1f48a2bf138603c913"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build
  depends_on "openssl@3"

  uses_from_macos "expat"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "./bootstrap.sh"
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <strophe.h>
      #include <assert.h>

      int main(void) {
        xmpp_ctx_t *ctx;
        xmpp_log_t *log;

        xmpp_initialize();
        log = xmpp_get_default_logger(XMPP_LEVEL_DEBUG);
        assert(log);

        ctx = xmpp_ctx_new(NULL, log);
        assert(ctx);

        xmpp_ctx_free(ctx);
        xmpp_shutdown();
        return 0;
      }
    C
    flags = ["-I#{include}/", "-L#{lib}", "-lstrophe"]
    system ENV.cc, "-o", "test", "test.c", *(flags + ENV.cflags.to_s.split)
    system "./test"
  end
end
