class Libxft < Formula
  desc "X.Org: X FreeType library"
  homepage "https://www.x.org/"
  url "https://www.x.org/archive/individual/lib/libXft-2.3.9.tar.xz"
  sha256 "60a25b78945ed6932635b3bb1899a517d31df7456e69867ffba27f89ff3976f5"
  license "MIT"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "029403b085a933f82ecb960f9d263b5afa7ca397de39c09b4dbd0b60a6918ca7"
    sha256 cellar: :any,                 arm64_sequoia: "0e9f1e46fca53790299056250ce221812c0b88bebb05e1c9c642bfb695bf0879"
    sha256 cellar: :any,                 arm64_sonoma:  "48764441d540c7b8711b64cf373adeae38d7a62823be70a466c38bf39c6dab88"
    sha256 cellar: :any,                 arm64_ventura: "8bdf668b5d06f1225412ce7c5ce6dbe78a80c82ff54a80662592429ef8ac8b08"
    sha256 cellar: :any,                 sonoma:        "266e09f717174e5fdbc01c7a35ceca534d0de45e0eee073938ad3e6b0aaaec78"
    sha256 cellar: :any,                 ventura:       "fa9940d070603876c53888c2442d49339a4c971cdd9bc4284cd861304df07e31"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "24ab212aedfbe76096d5d48ae6a27ca7af4146b351df27b96b3136bef762af1b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dadcce8067a08c22dc9ccce62bdaa8d0a3161d2036c74c14925c13d8c1b33c7b"
  end

  depends_on "pkgconf" => :build
  depends_on "fontconfig"
  depends_on "freetype"
  depends_on "libx11"
  depends_on "libxrender"

  def install
    args = %W[
      --sysconfdir=#{etc}
      --localstatedir=#{var}
      --disable-silent-rules
    ]

    system "./configure", *args, *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~C
      #include "X11/Xft/Xft.h"

      int main(int argc, char* argv[]) {
        XftFont font;
        return 0;
      }
    C
    system ENV.cc, "-I#{Formula["freetype"].opt_include}/freetype2", "test.c"
  end
end
