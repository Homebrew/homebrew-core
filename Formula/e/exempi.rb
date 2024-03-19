class Exempi < Formula
  desc "Library to parse XMP metadata"
  homepage "https://wiki.freedesktop.org/libopenraw/Exempi/"
  url "https://libopenraw.freedesktop.org/download/exempi-2.6.5.tar.bz2"
  sha256 "e9f9a3d42bff73b5eb0f77ec22cd0163c3e21949cc414ad1f19a0465dde41ffe"
  license "BSD-3-Clause"

  livecheck do
    url "https://libopenraw.freedesktop.org/exempi/"
    regex(/href=.*?exempi[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "fffe2e2da9ff2117ed01b3055811aa6b3c0348f33ca7da88bed84bbab3345767"
    sha256 cellar: :any,                 arm64_ventura:  "f97b4edaedaf3346999176b2f790bee721e9684c4faba1fd6d8b4f95df5a512d"
    sha256 cellar: :any,                 arm64_monterey: "3ea8dc1aaca7c2c12bd2673bdcb73dcb4c6f8fb6a928c9369e4cfcad5841e302"
    sha256 cellar: :any,                 sonoma:         "d4a92c827d8e702c9de91c44749c4448b611fea06b2a0cb444b505366e80f3f7"
    sha256 cellar: :any,                 ventura:        "ca6ef07fd6862b9148a8cabe608c0937f9da287638eec78d7402b29ba76c7fe2"
    sha256 cellar: :any,                 monterey:       "9595f29483fb85b894f482fd86221d791a02878bf5395638b63d90313abbf890"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "30ae54f527539c8f605086923bb33cb44560cb84bca42c06ec052d74a894f14c"
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
