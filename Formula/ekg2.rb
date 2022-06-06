class Ekg2 < Formula
  desc "Multiplatform, multiprotocol, plugin-based instant messenger"
  homepage "https://github.com/ekg2/ekg2"
  url "https://src.fedoraproject.org/lookaside/extras/ekg2/ekg2-0.3.1.tar.gz/68fc05b432c34622df6561eaabef5a40/ekg2-0.3.1.tar.gz"
  mirror "https://web.archive.org/web/20161227025528/pl.ekg2.org/ekg2-0.3.1.tar.gz"
  sha256 "6ad360f8ca788d4f5baff226200f56922031ceda1ce0814e650fa4d877099c63"
  license "GPL-2.0"
  revision 4

  livecheck do
    url :homepage
    regex(/^ekg2[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_monterey: "70fd07bef46d76450a77c68cc6633201080b11c2caacdc5b0a857eaec2bc9ebe"
    sha256 arm64_big_sur:  "e1ca8c485b595b3d8a0edcd59699c99d280a14d3aa7bfd7646c6d966f903101f"
    sha256 monterey:       "6ebb96a39595e0138fec66f379b7db080169ad019cae73943b43b48e958f777c"
    sha256 big_sur:        "2f095607ab5e5bdbf0ca515983aeff44e4a2480d97fb460d19c63babd875bd05"
    sha256 catalina:       "e17ea1385008892e80e0d5e0d44e510f6ac30e5d86423b55c61465eccd348d36"
    sha256 mojave:         "78778e95338d2a0a61f7d4773716d927534d24e4d5867a04038401427b07c855"
    sha256 high_sierra:    "f946e56a032b9526280745e6e57f8bc42a18d12fa9ced783f5515eb600bcdf0b"
    sha256 sierra:         "35f01a57bbceb1a79abfa8b035e3135d0c821bbca22a63b273e32159e517813f"
    sha256 x86_64_linux:   "a06b460073a25e212fc0488167281a438e4c72bc79ae30f204ea0d0d16643edc"
  end

  depends_on "pkg-config" => :build
  depends_on "openssl@1.1"
  depends_on "readline"

  # Fix the build on OS X 10.9+
  # bugs.ekg2.org/issues/152 [LOST LINK]
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/85fa66a9/ekg2/0.3.1.patch"
    sha256 "6efbb25e57581c56fe52cf7b70dbb9c91c9217525b402f0647db820df9a14daa"
  end

  # Upstream commit, fix build against OpenSSL 1.1
  patch do
    url "https://github.com/ekg2/ekg2/commit/f05815.patch?full_index=1"
    sha256 "207639edc5e6576c8a67301c63f0b28814d9885f0d4fca5d9d9fc465f4427cd7"
  end

  def install
    readline = Formula["readline"].opt_prefix

    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
      --enable-unicode
      --with-readline=#{readline}
      --without-gtk
      --without-libgadu
      --without-perl
      --without-python
    ]

    system "./configure", *args
    system "make", "install"
  end

  test do
    system "#{bin}/ekg2", "--help"
  end
end
