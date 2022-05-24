class Lnav < Formula
  desc "Curses-based tool for viewing and analyzing log files"
  homepage "https://lnav.org/"
  url "https://github.com/tstack/lnav/releases/download/v0.10.1/lnav-0.10.1.tar.gz"
  sha256 "a1fd65916bf06e5f01f07aca73ff9cca783f0562465facdf28fa24e9cf568209"
  license "BSD-2-Clause"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "19feba2a42503e1bddbc247e2d6c72e59ccf4cdb25f8ef18fef050e054d4eb89"
    sha256 cellar: :any,                 arm64_big_sur:  "d162151f7043144d24b47c6ae23b61cdbb71959b5c77bba016e0f3d538dc432b"
    sha256 cellar: :any,                 monterey:       "eab9bc062c791cf77864916cc055b281b593d153c5afd165171fb554203ecd67"
    sha256 cellar: :any,                 big_sur:        "57dcbc897e03444f03e78e2fbeaf9c20c65b8b4ba93c759da5118b206007fe04"
    sha256 cellar: :any,                 catalina:       "c137529abc15c63b8e4d865f433712355b5f6fc750ac76c177f805cb7813dd44"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bd04107f50f8d01f00f476ad87ae8228416f81a3124e0a3d64948d7fd2d695fc"
  end

  head do
    url "https://github.com/tstack/lnav.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "re2c" => :build
  end

  depends_on "libarchive"
  depends_on "pcre"
  depends_on "readline"
  depends_on "sqlite"

  on_linux do
    depends_on "gcc"
  end

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
