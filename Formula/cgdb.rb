class Cgdb < Formula
  desc "Curses-based interface to the GNU Debugger"
  homepage "https://cgdb.github.io/"
  url "https://cgdb.me/files/cgdb-0.8.0.tar.gz"
  sha256 "0d38b524d377257b106bad6d856d8ae3304140e1ee24085343e6ddf1b65811f1"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://cgdb.me/files/"
    regex(/href=.*?cgdb[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "cf029cddf3d08875c2f363d6ed9df10bfb944830d448557784e669138a3aefa5"
    sha256 arm64_big_sur:  "1dfbebad73683e283033ce308c131a9509a1db30df30830f8177c08f631b69c4"
    sha256 monterey:       "8fd498ac0f53354ec1b2298e5b6d0bf5d11f2047ca0df29b44b3b31a6bf89682"
    sha256 big_sur:        "82301d4bbc42f2feea9b20676554ed96360d7ce7626b5ef02afb6e76983818f6"
    sha256 catalina:       "0cf4c2cd5ed2f6b831581d06d3f9614007aaecc16bc4ba0a1fce85afa81a11ee"
    sha256 x86_64_linux:   "cb3a12c3700e55375cffe843a4bdf8e4fe2541219dc1da35304f7dbece2f5809"
  end

  head do
    url "https://github.com/cgdb/cgdb.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "help2man" => :build
  depends_on "readline"

  uses_from_macos "flex" => :build
  uses_from_macos "texinfo" => :build

  def install
    system "sh", "autogen.sh" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-readline=#{Formula["readline"].opt_prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/cgdb", "--version"
  end
end
