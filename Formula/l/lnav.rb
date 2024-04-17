class Lnav < Formula
  desc "Curses-based tool for viewing and analyzing log files"
  homepage "https://lnav.org/"
  license "BSD-2-Clause"

  stable do
    url "https://github.com/tstack/lnav/releases/download/v0.12.1/lnav-0.12.1.tar.gz"
    sha256 "d4565fbe29ad00e1e00efc6bff68e2068e102ace95ff296610d2bd6c04b13d67"

    # patch to fix static init issue running on 12-arm
    # upstream release request, https://github.com/tstack/lnav/issues/1250
    patch do
      url "https://github.com/tstack/lnav/commit/884e6b7415c562621487abe922fd3042da71ff32.patch?full_index=1"
      sha256 "a6e6bf235159f3a4a3af82a01099b4aaf70e102f84e925d8d2f8d867b0d7f2b6"
    end
  end

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "bd3dbaa76d7a1deb296efe140d3b08b9ae0e8bcce42269bac16281151a1b4d46"
    sha256 cellar: :any,                 arm64_ventura:  "c03179e86b05f4f47a056785f30baea4d17cc97b3d45f204f75536b346d92cf4"
    sha256 cellar: :any,                 arm64_monterey: "154f40bfc3d17244568c748d0ce603aeaa9cab5a911492ac015b99cebb885611"
    sha256 cellar: :any,                 sonoma:         "c1b98b1846940ed29226a5a4aed95b19c17ce3aa0ad49696ac12f7063bcbf64e"
    sha256 cellar: :any,                 ventura:        "71bc7c2a01d3eedb4a98e2b5657feb7cc03a2cd31a2a6d99be8e5804f501e343"
    sha256 cellar: :any,                 monterey:       "9632b430d6b4366adf721c55458f47df3b3af22fdb19219187806939d1af8f57"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "099c89d4474104e62d6f737e7338a6b79d4ab70b5e09b25365f7e1a33be39664"
  end

  head do
    url "https://github.com/tstack/lnav.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "re2c" => :build
  end

  depends_on "libarchive"
  depends_on "ncurses"
  depends_on "pcre2"
  depends_on "readline"
  depends_on "sqlite"
  uses_from_macos "curl"

  fails_with gcc: "5"

  def install
    system "./autogen.sh" if build.head?
    system "./configure", *std_configure_args,
                          "--with-sqlite3=#{Formula["sqlite"].opt_prefix}",
                          "--with-readline=#{Formula["readline"].opt_prefix}",
                          "--with-libarchive=#{Formula["libarchive"].opt_prefix}",
                          "--with-ncurses=#{Formula["ncurses"].opt_prefix}"
    system "make", "install", "V=1"
  end

  test do
    system "#{bin}/lnav", "-V"
  end
end
