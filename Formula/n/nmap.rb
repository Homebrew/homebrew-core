class Nmap < Formula
  desc "Port scanning utility for large networks"
  homepage "https://nmap.org/"
  url "https://nmap.org/dist/nmap-7.98.tar.bz2"
  sha256 "ce847313eaae9e5c9f21708e42d2ab7b56c7e0eb8803729a3092f58886d897e6"
  license :cannot_represent
  revision 1
  compatibility_version 1
  head "https://svn.nmap.org/nmap/"

  livecheck do
    url "https://nmap.org/download"
    regex(/href=.*?nmap[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "64b89fa933591f6ca2b7fd1ce45c70859f549955a6941e3e1070a79f1be83a1b"
    sha256 arm64_sequoia: "63ef0acfe123c65f364f19ddae8621eb050fa618e4749c51f62ff54c5fa59966"
    sha256 arm64_sonoma:  "38b8de5522f3cbccb812c1e61696d16b27b267716fd2bd67b3dbd4f4846236a3"
    sha256 sonoma:        "464ffaf24758602b9e53eef5f4cae49b97ad1ece9b339145c6044e4e5faf09d7"
    sha256 arm64_linux:   "56420284aa2c62c55f96cf332868ad12ce23e1583edf54a2543ee8c5a8c3edd3"
    sha256 x86_64_linux:  "9eac9fadda8834f10a1c8a407714522625818d912a1c99f31c57435ae14c6cc0"
  end

  depends_on "python-setuptools" => :build
  depends_on "liblinear"
  depends_on "libssh2"
  # Check supported Lua version at https://github.com/nmap/nmap/tree/master/liblua.
  depends_on "lua"
  depends_on "openssl@3"
  depends_on "pcre2"
  depends_on "python@3.14" # for ndiff

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build
  uses_from_macos "libpcap"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  conflicts_with "cern-ndiff", "ndiff", because: "both install `ndiff` binaries"
  conflicts_with cask: "zenmap", because: "both install `nmap` binaries"

  def install
    # Fix to missing VERSION file
    # https://github.com/nmap/nmap/pull/3111
    mv "libpcap/VERSION.txt", "libpcap/VERSION"

    ENV.deparallelize

    libpcap_path = if OS.mac?
      MacOS.sdk_path/"usr/"
    else
      Formula["libpcap"].opt_prefix
    end

    args = %W[
      --with-liblua=#{Formula["lua"].opt_prefix}
      --with-libpcre=#{Formula["pcre2"].opt_prefix}
      --with-openssl=#{Formula["openssl@3"].opt_prefix}
      --with-libpcap=#{libpcap_path}
      --without-nmap-update
      --disable-universal
      --without-zenmap
      --without-ndiff
    ]

    system "./configure", *args, *std_configure_args
    system "make" # separate steps required otherwise the build fails
    system "make", "install"

    # Install `ndiff` separately so that we can use `pip` and `setuptools`.
    system "python3", "-m", "pip", "install", *std_pip_args, "./ndiff"
    bin.glob("uninstall_*").map(&:unlink) # Users should use brew uninstall.
  end

  test do
    system bin/"nmap", "-p80,443", "-oX", "scan1.xml", "google.com"
    cp "scan1.xml", "scan2.xml"
    system bin/"ndiff", "scan1.xml", "scan2.xml"
  end
end
