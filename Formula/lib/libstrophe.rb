class Libstrophe < Formula
  desc "XMPP library for C"
  homepage "https://strophe.im/libstrophe/"
  url "https://github.com/strophe/libstrophe/archive/refs/tags/0.14.0.tar.gz"
  sha256 "adeb9e673d7f8b8cd20a2437cc220a8de581abf6e46594896b622e3e0dfa5c1f"
  license all_of: ["GPL-3.0-only", "MIT"]
  head "https://github.com/strophe/libstrophe.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "d03a5cd85ad0c216e28135147a74744847eb32c4e6f4ec52f7de8700098c71b0"
    sha256 cellar: :any,                 arm64_sequoia: "9b73c7be79de4da6cdf71493be1d7cfebeb793118cc3e8c81f38e1e300c7655a"
    sha256 cellar: :any,                 arm64_sonoma:  "26a68ff8af0c493458d249c831bc9951d9167f67524a61a815aefe3735c90b05"
    sha256 cellar: :any,                 arm64_ventura: "871b9da7491c846d8577fbd1497bf835abc2c529148d94f9124953fe602568da"
    sha256 cellar: :any,                 sonoma:        "91bae15485f397f9eb581cd9611f636320aa76e2671981bd702893f2095b360b"
    sha256 cellar: :any,                 ventura:       "f56d42d26c8a1540ef92878b9a89262a1769c39904604bd878139570f977bbb5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fdf712f1639e7fb2d4e57aa5708f017059839265d95e1884b45721d6f19f3d68"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "82556dd0b8ebd7541b35c3ea0e4c4079f802a4588c0424043a64b277416394fc"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build
  depends_on "openssl@3"

  uses_from_macos "expat"
  uses_from_macos "zlib"

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
