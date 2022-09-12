class Lnav < Formula
  desc "Curses-based tool for viewing and analyzing log files"
  homepage "https://lnav.org/"
  url "https://github.com/tstack/lnav/releases/download/v0.11.0/lnav-0.11.0.tar.gz"
  sha256 "d3fa5909af8e5eb2aa7818b90120cae35aa7dd1775a3b0d2097d7e6075b8f935"
  license "BSD-2-Clause"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "68192f036d31470c82966434ca14af6d647929e67ce58f03a549b28991f78c00"
    sha256 cellar: :any,                 arm64_big_sur:  "bdd76d98b34fad9714ce922c951d33f5caacf8c5b7be2ffca868d4e2271245c0"
    sha256 cellar: :any,                 monterey:       "662ef55af0f76c8f81c017178b1b0c683545fdf4516f5ad82eafe597b6ff82c3"
    sha256 cellar: :any,                 big_sur:        "0fa0bc4dc53a31d7c8651c37679a711c2ba44dbcdf75bbd806c2b8599bfed26c"
    sha256 cellar: :any,                 catalina:       "88850c2b768144d4722a373d48f703c99702e293563cd42b4d20771c7106978b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fc94900ee6c9f3d74628c23405b3025e3953fa1c123fa37e1493e42dd8cfa439"
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
