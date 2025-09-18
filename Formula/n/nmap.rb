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
    rebuild 1
    sha256 arm64_tahoe:   "5973d94f7f57b7ceadb5fa25cb44e713c36275a6346b5ac0fa5350bd225aaee8"
    sha256 arm64_sequoia: "a03b34a68f4a64e05ea7d13bedfcaf95df08024f8535d0ee421adbb4d5c4779f"
    sha256 arm64_sonoma:  "95c388f63d4e8c2c5684420bab57f68a856e04815ec524336377cd4abd50808f"
    sha256 arm64_ventura: "e58642363109486b81fcd6d9ad43bc55e89f6f278484ea3c7b7394839cb0677f"
    sha256 sonoma:        "34b141f30a9dadc00a0290a043fea4ea7096a5a055a455d2fc49388e49d87c52"
    sha256 ventura:       "9c7c34cbd9b4053df2709c903c9488e0e8c7c64bf1be3e7fa1b4206c8a1ea0f0"
    sha256 arm64_linux:   "efc2e738c069175b74452d9ad521e2b3c5e0da2e0b64c0f5a661dbb699e51c50"
    sha256 x86_64_linux:  "c9532f3302a83a7c74ecc12308b980cf162e002187dad961bdf9eb10bca0126b"
  end

  depends_on "python-setuptools" => :build
  depends_on "liblinear"
  depends_on "libssh2"
  # Check supported Lua version at https://github.com/nmap/nmap/tree/master/liblua.
  depends_on "lua"
  depends_on "openssl@3"
  depends_on "pcre2"
  depends_on "python@3.13" # for ndiff

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
