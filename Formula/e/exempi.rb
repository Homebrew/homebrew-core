class Exempi < Formula
  desc "Library to parse XMP metadata"
  homepage "https://wiki.freedesktop.org/libopenraw/Exempi/"
  url "https://libopenraw.freedesktop.org/download/exempi-2.6.4.tar.bz2"
  sha256 "a75149c96b61e39cdcb046fd5e56d88cfeeab6e08f894e15ebffd9944092bfd0"
  license "BSD-3-Clause"

  livecheck do
    url "https://libopenraw.freedesktop.org/exempi/"
    regex(/href=.*?exempi[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "e9e2b6ef7dc27709e30e5db394efda2061fee85cf6536bba8617db248008810e"
    sha256 cellar: :any,                 arm64_ventura:  "6733c5085687e257be06829bcfa4d0d44124f4ae56a124ad57a33147814fe10e"
    sha256 cellar: :any,                 arm64_monterey: "5d367e84c1459c0c9a9067b7878cb9ff17b5e2aae5594c66001b08f9dead3195"
    sha256 cellar: :any,                 arm64_big_sur:  "8b03a1019a97026290da6863505b5052beb576e67c73ddf20b85ef92fcc40743"
    sha256 cellar: :any,                 sonoma:         "d171d82add6bbd61027636c09326543da1be3903235026ad0c655500b361d36b"
    sha256 cellar: :any,                 ventura:        "708f780b95cb40c5a7610612d139b3a9177d98476f29bd6f589f4ab738f13c53"
    sha256 cellar: :any,                 monterey:       "bf0216d43fb1e48802e79fdd0e932feda6a1cb937b49e5a464de2a777413a4d6"
    sha256 cellar: :any,                 big_sur:        "12b82191940f7701e505e8a1c594e4c0ce3f1c87bee41da649c8ff6256ce1fb4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f77b16ed1ae219804b9d65ad3318107bbfa54fafe646b38d838c9c34e4a40506"
  end

  depends_on "boost"

  uses_from_macos "expat"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-boost=#{HOMEBREW_PREFIX}"
    system "make", "install"
  end
end
