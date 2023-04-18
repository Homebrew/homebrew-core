class CrosstoolNg < Formula
  desc "Tool for building toolchains"
  homepage "https://crosstool-ng.github.io/"
  url "http://crosstool-ng.org/download/crosstool-ng/crosstool-ng-1.25.0.tar.xz"
  sha256 "68162f342243cd4189ed7c1f4e3bb1302caa3f2cbbf8331879bd01fe06c60cd3"
  license "GPL-2.0-only"
  head "https://github.com/crosstool-ng/crosstool-ng.git", branch: "master"

  livecheck do
    url "https://crosstool-ng.github.io/download/"
    regex(/href=.*?crosstool-ng[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "da0b42cf1239cb133d7dc6862671d0d3debc4f67db4b8c5ad322dad49709c519"
    sha256 cellar: :any,                 arm64_monterey: "d1d2a99a0f22af7153a165b2dc72541094bf7bdaf993a00899f84f02888f6a53"
    sha256 cellar: :any,                 arm64_big_sur:  "d9b7df3a04edcdc51f34f60a2cb78c888eb90e31451fe02e60d83f972ed222c1"
    sha256 cellar: :any,                 ventura:        "5c26c9c40110c1c92da9154d2c4fb3d5eb2ffcb66ca7c995090382ca74f983ab"
    sha256 cellar: :any,                 monterey:       "8726ee9c9bd3681c32b2cdfb6244dffa1d4930248f5c3259ca644318e54d01b5"
    sha256 cellar: :any,                 big_sur:        "ca4b8bfba4291c253b52159f7f600fc1b5ce3bd49961a9db0eb678e4949e2cd1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "78bcc039c0893b52f57eb794368e2ce47dc0f41f9d2dad2ed08312b6bd79cf79"
  end

  depends_on "help2man" => :build
  depends_on "autoconf"
  depends_on "automake"
  depends_on "binutils"
  depends_on "bison"
  depends_on "flex"
  depends_on "gettext"
  depends_on "libtool"
  depends_on "lzip"
  depends_on "m4"
  depends_on "ncurses"
  depends_on "python@3.11"
  depends_on "xz"

  uses_from_macos "flex" => :build
  uses_from_macos "gperf" => :build
  uses_from_macos "unzip" => :build

  on_macos do
    depends_on "bash"
    depends_on "coreutils"
    depends_on "gawk"
    depends_on "gnu-sed"
    depends_on "grep"
    depends_on "make"
  end

  on_system :linux, macos: :ventura_or_newer do
    depends_on "texinfo" => :build
  end

  def install
    system "./bootstrap" if build.head?

    ENV["BISON"] = Formula["bison"].opt_bin/"bison"
    ENV["M4"] = Formula["m4"].opt_bin/"m4"
    ENV["PYTHON"] = Formula["python@3.11"].opt_bin/"python3.11"

    if OS.mac?
      ENV["MAKE"] = Formula["make"].opt_bin/"gmake"
      ENV.append "LDFLAGS", "-lintl"
    else
      ENV.append "CFLAGS", "-I#{Formula["ncurses"].include}/ncursesw"
    end

    system "./configure", "--prefix=#{prefix}"

    # Must be done in two steps
    system "make"
    system "make", "install"

    inreplace [bin/"ct-ng", pkgshare/"paths.sh"], Superenv.shims_path/"make", "make" unless OS.mac?
  end

  test do
    assert_match "This is crosstool-NG", shell_output("make -rf #{bin}/ct-ng version")
  end
end
