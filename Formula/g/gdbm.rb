class Gdbm < Formula
  desc "GNU database manager"
  homepage "https://www.gnu.org.ua/software/gdbm/"
  url "https://ftp.gnu.org/gnu/gdbm/gdbm-1.25.tar.gz"
  mirror "https://ftpmirror.gnu.org/gdbm/gdbm-1.25.tar.gz"
  sha256 "d02db3c5926ed877f8817b81cd1f92f53ef74ca8c6db543fbba0271b34f393ec"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any, arm64_sequoia: "ce13d6f53ca09fb01e34f336ed2ba2660d8fd107bc1d374ea12cbd94e3bd2c10"
    sha256 cellar: :any, arm64_sonoma:  "d2304cf89d5b8c541c022853331778277ea4de0d022e3abfa6aecca5a6bd78ed"
    sha256 cellar: :any, arm64_ventura: "f9f48845d498e891b96b837c37eb4c8fb92c92e8f022f2d6ff6a612dafcb8e1b"
    sha256 cellar: :any, sonoma:        "5bc39e26b0b9ea73860e069a7520ad0515e274d72633ec8af1e88761433a1544"
    sha256 cellar: :any, ventura:       "17ab62fd1807c70aea51fae0dd267b8691022165fd5a472364e12292f320e7ee"
    sha256               arm64_linux:   "75703cd648a7bd05140336811cac1ad4034adf64b98c0e509bae8e60badff1cb"
    sha256               x86_64_linux:  "7bb95130a0f0f4a3c938f798edb331abae374db148ed14fa080568c5db95cfef"
  end

  # Backport fix for macOS
  patch do
    url "https://git.savannah.gnu.org/cgit/gdbm.git/patch/?id=ed0a865345681982ea02c6159c0f3d7702c928a1"
    sha256 "d2ba39d1948f5b1f048997716beaaa96d07fba594e81854cb01574378f645e07"
  end

  def install
    # --enable-libgdbm-compat for dbm.h / gdbm-ndbm.h compatibility:
    #   https://www.gnu.org.ua/software/gdbm/manual/html_chapter/gdbm_19.html
    # Use --without-readline because readline detection is broken in 1.13
    # https://github.com/Homebrew/homebrew-core/pull/10903
    args = %w[
      --disable-silent-rules
      --enable-libgdbm-compat
      --without-readline
    ]

    system "./configure", *args, *std_configure_args
    system "make", "install"

    # Avoid conflicting with macOS SDK's ndbm.h.  Renaming to gdbm-ndbm.h
    # matches Debian's convention for gdbm's ndbm.h (libgdbm-compat-dev).
    mv include/"ndbm.h", include/"gdbm-ndbm.h"
  end

  test do
    pipe_output("#{bin}/gdbmtool --norc --newdb test", "store 1 2\nquit\n")
    assert_path_exists testpath/"test"
    assert_match "2", pipe_output("#{bin}/gdbmtool --norc test", "fetch 1\nquit\n")
  end
end
