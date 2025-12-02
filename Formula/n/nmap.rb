class Nmap < Formula
  desc "Port scanning utility for large networks"
  homepage "https://nmap.org/"
  url "https://nmap.org/dist/nmap-7.98.tar.bz2"
  sha256 "ce847313eaae9e5c9f21708e42d2ab7b56c7e0eb8803729a3092f58886d897e6"
  license :cannot_represent
  head "https://svn.nmap.org/nmap/"

  livecheck do
    url "https://nmap.org/download"
    regex(/href=.*?nmap[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 2
    sha256 arm64_tahoe:   "8b0c683be0468cbabf353946294009fab7e90f0cc2926eb660d85911037078a4"
    sha256 arm64_sequoia: "c3acbe15e9c4599441d2c765fcf1791b7c5d51183a6bfe56662f861d1547b11a"
    sha256 arm64_sonoma:  "d81b6a59b8fe79a572e8b5c26a4cea2e946a42ddac395e78bac36bd422241d7a"
    sha256 sonoma:        "b3d02143aa6f854448be7dd1b9a240a79fbb293358378269f788b275d9bd968e"
    sha256 arm64_linux:   "b3e6690a7aec429fa84f4f6281c6c288f84be08bfc4439875008a60359c0c9c6"
    sha256 x86_64_linux:  "9700259f97a5d42d0c1e9e2c6c2ed03059dd2bc362d2eb45c106219b1fe0ac29"
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
  uses_from_macos "zlib"

  conflicts_with "cern-ndiff", "ndiff", because: "both install `ndiff` binaries"
  conflicts_with "nping", because: "both install `nping` binaries"
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
