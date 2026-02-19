class Lnav < Formula
  desc "Curses-based tool for viewing and analyzing log files"
  homepage "https://lnav.org/"
  url "https://github.com/tstack/lnav/releases/download/v0.13.2/lnav-0.13.2.tar.gz"
  sha256 "2b40158e36aafce780075e05419924faf8dd99d1c0d4ae25a15b00bc944f4d60"
  license "BSD-2-Clause"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 2
    sha256 cellar: :any,                 arm64_tahoe:   "46095011327647eac507bcbae0974cee22f854fe5976150754d49080e81fd55a"
    sha256 cellar: :any,                 arm64_sequoia: "945ceeaa372761b961cf7b34c64082a6a0cf3a564c732a7663b9fb2b06f73945"
    sha256 cellar: :any,                 arm64_sonoma:  "c0c0411af0bb0c719868c7dc78043ee40459d3f7a6fd3606b0339dae73e75ec6"
    sha256 cellar: :any,                 sonoma:        "9e7a4ea4ea60a0722141ed6ef952d2566da7487af2ff806c2373925b08700d3b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ed8fd3d41e2fbcb04e08ab3ce11237f9e03de50c96df1450ab85f7cffb111f7c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ae07d7f453c2bc9cd51abf4b11558c30216c2faaf0409c9f33700d0439b79db6"
  end

  head do
    url "https://github.com/tstack/lnav.git", branch: "master"

    depends_on "re2c" => :build
  end

  # TODO: Make autoconf and automake build deps on head only upon next release
  depends_on "autoconf" => :build
  depends_on "automake" => :build

  depends_on "rust" => :build
  depends_on "libarchive"
  depends_on "libunistring"
  depends_on "pcre2"
  depends_on "sqlite"

  uses_from_macos "bzip2"
  uses_from_macos "curl"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--with-sqlite3=#{Formula["sqlite"].opt_prefix}",
                          "--with-libarchive=#{Formula["libarchive"].opt_prefix}",
                          *std_configure_args
    system "make", "install", "V=1"
  end

  test do
    system bin/"lnav", "-V"

    assert_match "col1", pipe_output("#{bin}/lnav -n -c ';from [{ col1=1 }] | take 1'", "foo")
  end
end
