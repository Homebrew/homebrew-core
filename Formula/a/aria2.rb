class Aria2 < Formula
  desc "Download with resuming and segmented downloading"
  homepage "https://aria2.github.io/"
  url "https://github.com/aria2/aria2/releases/download/release-1.36.0/aria2-1.36.0.tar.xz"
  sha256 "58d1e7608c12404f0229a3d9a4953d0d00c18040504498b483305bcb3de907a5"
  license "GPL-2.0-or-later"
  revision 2

  bottle do
    sha256 arm64_sonoma:   "62ba159a87cc2fb2a8d925a5d905594935865abfd2d77ff419192108f5ecfc2e"
    sha256 arm64_ventura:  "731a149db13b22d75a8b83822eabefabe3242208db9e683f5124cdd0d0c72411"
    sha256 arm64_monterey: "1c89b3ecb3198cb66b0ee42205f237380115ee593c7af6c13d977f79c4c2ba9d"
    sha256 arm64_big_sur:  "565453d34817d8a867db81957c96bbcc810e3fa3837926aa170ff11f03dfe001"
    sha256 sonoma:         "f665f23dcdaa1b4569355bade26ff0a68d6922dc75acb2d06360afcbeff6afb9"
    sha256 ventura:        "b81e1f4fd082425ded765ee045a5c398d3fb8dc2ed2419938ce4c6ae2f58e376"
    sha256 monterey:       "ac0d8d8b627ff85c9aae7b56dc26cde0bae0c5641e4fe6b7381b9205b3e84b6a"
    sha256 big_sur:        "43bdd51855a48f06ee8d8c891575ca7cf5329147c706a0c8f70db6c6f45680b3"
    sha256 x86_64_linux:   "2a6786075c3cfb617e3691f193a7a8450b10b211022326b56d0aebc42f44d22f"
  end

  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "libssh2"
  depends_on "openssl@3"
  depends_on "sqlite"

  uses_from_macos "libxml2"
  uses_from_macos "zlib"

  def install
    ENV.cxx11

    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --with-libssh2
      --without-gnutls
      --without-libgmp
      --without-libnettle
      --without-libgcrypt
    ]
    if OS.mac?
      args << "--with-appletls"
      args << "--without-openssl"
    else
      args << "--without-appletls"
      args << "--with-openssl"
    end

    system "./configure", *args
    system "make", "install"

    bash_completion.install "doc/bash_completion/aria2c"
  end

  test do
    system "#{bin}/aria2c", "https://brew.sh/"
    assert_predicate testpath/"index.html", :exist?, "Failed to create index.html!"
  end
end
