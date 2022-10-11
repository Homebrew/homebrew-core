class Lnav < Formula
  desc "Curses-based tool for viewing and analyzing log files"
  homepage "https://lnav.org/"
  url "https://github.com/tstack/lnav/releases/download/v0.11.1/lnav-0.11.1.tar.gz"
  sha256 "7685b7b3c61c54a1318b655f78c932aca25fa0f5b20ea9b0ea6a58c7f9852cd0"
  license "BSD-2-Clause"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_monterey: "e51730f08b4c25a058b5a6925d749d292f7a34eee829cd0028aae93f7b3447d7"
    sha256 cellar: :any,                 arm64_big_sur:  "c02f6a4c62725349bb24336ee3bebd325f3615f474236f2a9ca95d2119b22283"
    sha256 cellar: :any,                 monterey:       "ceec299dc99dc1ed5d230e9a81d4f50b86451b61827314d4e796b303e35c323c"
    sha256 cellar: :any,                 big_sur:        "e418b8dd04fc1b7193968e4dbcad1e7652cae0649c05d99673be778594aa00fe"
    sha256 cellar: :any,                 catalina:       "c28f62a13c4618830fd145c5b449d24f3df92d681c61dd456f0756d1620d79e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6b089fd04dc4d3eac67c4890a551027325e0f583c8c0b7050cc9bf5fe7eff706"
  end

  head do
    url "https://github.com/tstack/lnav.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "re2c" => :build
  end

  depends_on "libarchive"
  depends_on "pcre2"
  depends_on "readline"
  depends_on "sqlite"
  uses_from_macos "curl"

  fails_with gcc: "5"

  def install
    system "./autogen.sh" if build.head?
    ENV.append "LDFLAGS", "-L#{Formula["libarchive"].opt_lib}"
    system "./configure", *std_configure_args,
                          "--with-sqlite3=#{Formula["sqlite"].opt_prefix}",
                          "--with-readline=#{Formula["readline"].opt_prefix}",
                          "--with-libarchive=#{Formula["libarchive"].opt_prefix}",
                          "LDFLAGS=#{ENV.ldflags}"
    system "make", "install", "V=1"
  end

  test do
    system "#{bin}/lnav", "-V"
  end
end
