class Hfstospell < Formula
  desc "Helsinki Finite-State Technology ospell"
  homepage "https://hfst.github.io/"
  url "https://github.com/hfst/hfst-ospell/releases/download/v0.5.2/hfst-ospell-0.5.2.tar.bz2"
  sha256 "ab9ccf3c2165c0efd8dd514e0bf9116e86a8a079d712c0ed6c2fabf0052e9aa4"
  license "Apache-2.0"
  revision 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "758ed5ec9ea9fc762b891ff8f27d83a840195fe86636cd9706115063841dcf0d"
    sha256 cellar: :any, big_sur:       "9bef29b829d94f52c22206e365f364a604620c194fefea2134ba0827fee6b5a8"
    sha256 cellar: :any, catalina:      "93b6e9890e78fcde61b18277861e3c3ec77039e22f4c9c723078791d787521e0"
    sha256 cellar: :any, mojave:        "f33ba3c1c11a54a7c349b41a6c230735b54cf6c58314a3a4d3fa3a8d9b1fe809"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "icu4c"
  depends_on "libarchive"

  def install
    ENV.cxx11
    system "autoreconf", "-fiv"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--without-libxmlpp",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/hfst-ospell", "--version"
  end
end
