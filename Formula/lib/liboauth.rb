class Liboauth < Formula
  desc "C library for the OAuth Core RFC 5849 standard"
  homepage "https://sourceforge.net/projects/liboauth/"
  url "https://downloads.sourceforge.net/project/liboauth/liboauth-1.0.3.tar.gz"
  sha256 "0df60157b052f0e774ade8a8bac59d6e8d4b464058cc55f9208d72e41156811f"
  # if configured with '--enable-gpl' see COPYING.GPL and LICENSE.OpenSSL
  # otherwise read COPYING.MIT
  license "MIT"
  revision 3

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "a510309b244c20d084bcac6d01a80b888c0bb2e89ee67e8c7be5fdd4cdf28f84"
    sha256 cellar: :any,                 arm64_sequoia:  "4eff11a4e53ab448c41469596fadeac63b03386c90c1f091372fc003f497562a"
    sha256 cellar: :any,                 arm64_sonoma:   "6f8593691c180a940c09d3cdb22c5f69fb4ac7dfb8877581b5cc13a02b6088a1"
    sha256 cellar: :any,                 arm64_ventura:  "a39ee9626caffc0652551afceb3de434b14f497d0e6f86888edfb987f0e46bfb"
    sha256 cellar: :any,                 arm64_monterey: "14eb9710933a0f1e3974449b3451288160147295e1a941ed41720af29b62c9e2"
    sha256 cellar: :any,                 arm64_big_sur:  "76fdd8122c46982e11d80e4416c20f95a856c6ccdab50d94be6fffed926a52e6"
    sha256 cellar: :any,                 sonoma:         "82369227bbe96d217b653ca80bdb771a97fe5b4d2e04d581dea6a61396acc97a"
    sha256 cellar: :any,                 ventura:        "c428f77d8ce2e3ee3517782cfffcc442d6f136a98feaf969b9f0bc589a752ec0"
    sha256 cellar: :any,                 monterey:       "1ca737e530881673e82ccc350dfc769d1e30d6db94f5b77d2d2261216003f539"
    sha256 cellar: :any,                 big_sur:        "2a00f8fb82450e4acfec03f1e91dc74196ecf0150047b64a4357d6ac716d279c"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "d590a572f38268fe5b4a9ec90877b436030fe6ef35564681bd8af45f15a66186"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0177a7a4378d03aa25b46b4bc37bc12b777438fa177ef15b0dd16406cfad40ef"
  end

  depends_on "openssl@3"

  # Patch for compatibility with OpenSSL 1.1
  patch :p0 do
    url "https://raw.githubusercontent.com/freebsd/freebsd-ports/121e6c77a8e6b9532ce6e45c8dd8dbf38ca4f97d/net/liboauth/files/patch-src_hash.c"
    sha256 "a7b0295dab65b5fb8a5d2a9bbc3d7596b1b58b419bd101cdb14f79aa5cc78aea"
  end

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/homebrew-core/1cf441a0/Patches/libtool/configure-pre-0.4.2.418-big_sur.diff"
    sha256 "83af02f2aa2b746bb7225872cab29a253264be49db0ecebb12f841562d9a2923"
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-curl"
    system "make", "install"
  end
end
