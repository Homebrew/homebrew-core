class Libpst < Formula
  desc "Utilities for the PST file format"
  homepage "https://www.five-ten-sg.com/libpst/"
  url "https://www.five-ten-sg.com/libpst/packages/libpst-0.6.76.tar.gz"
  sha256 "3d291beebbdb48d2b934608bc06195b641da63d2a8f5e0d386f2e9d6d05a0b42"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://www.five-ten-sg.com/libpst/packages/"
    regex(/href=.*?libpst[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "19a3a8b7fde2b29f509e69232fd8ff7d924c5df201d63cf40512cd7b4831056d"
    sha256 cellar: :any,                 arm64_big_sur:  "d7b9d9f537b1575cbd299b56e2a82f38f661aff617cc8a3a03b44cf8acb1e3c0"
    sha256 cellar: :any,                 monterey:       "9acacad7e57b79446bd4d97551cc026be3cca70f03ac0d28f6622c91b2898c2e"
    sha256 cellar: :any,                 big_sur:        "be3136353a0d0c538070a6c1261b75620abffda9d2cee435daf3debbc5fe2f8e"
    sha256 cellar: :any,                 catalina:       "d6ec30b4b9ca7d8968c5155b98c2a32dca502910c6c95ac860dc50065de89f65"
    sha256 cellar: :any,                 mojave:         "9ba873578452d668ac195f1e3b332f692f45ee5db1a6c55e68e57e8d08d3878a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0ef7024943254ef22bbf082c8c96ce8d207c30a1b9fe77a8d6f4432d09f924aa"
  end

  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "gettext"
  depends_on "libgsf"

  def install
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --disable-python
    ]

    system "./configure", *args
    system "make"
    system "make", "install"
  end

  test do
    system bin/"lspst", "-V"
  end
end
