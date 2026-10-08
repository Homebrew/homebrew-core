class Nmap < Formula
  desc "Port scanning utility for large networks"
  homepage "https://nmap.org/"
  url "https://nmap.org/dist/nmap-7.991.tar.bz2"
  sha256 "a5d507f29437bef3bedd4771ff9aaa8fc1c2a109ddba1f5b1cf12027456929be"
  license :cannot_represent
  revision 1
  compatibility_version 1
  head "https://svn.nmap.org/nmap/"

  livecheck do
    url "https://nmap.org/download"
    regex(/href=.*?nmap[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_golden_gate: "7e1efad06959894b07fa340e3d36e51dac4090cf6d23e48694551f10b239135c"
    sha256 arm64_tahoe:       "f6739e639b4b1af576ecc01d0799bd5ddb3918b61af5ce43a22e7ec357b3fee5"
    sha256 arm64_sequoia:     "48f2ffa147eda489dd656b95de347494b4913715e0b59164df20ff80a4e6a865"
    sha256 arm64_linux:       "bcdee62675a7c60cb7c53478b3e8c146c83dd3e034dfe75bc87d3737d24c77f2"
    sha256 x86_64_linux:      "142a6521d7a319282f3d8c96ec36e4e48ce07f4c2e622e8015effd1d27958470"
  end

  depends_on "python-setuptools" => :build
  depends_on "liblinear"
  depends_on "libssh2"
  # Check supported Lua version at https://github.com/nmap/nmap/tree/master/liblua.
  depends_on "lua"
  depends_on "openssl@4"
  depends_on "pcre2"
  depends_on "python@3.14" # for ndiff

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build
  uses_from_macos "libpcap"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  conflicts_with "cern-ndiff", "ndiff", because: "both install `ndiff` binaries"

  # needs a network connection to test
  allow_network_access! :test

  def install
    # Fix to missing VERSION file
    # https://github.com/nmap/nmap/pull/3111
    mv "libpcap/VERSION.txt", "libpcap/VERSION"

    ENV.deparallelize

    libpcap_path = if OS.mac?
      MacOS.sdk_path/"usr/"
    else
      formula_opt_prefix("libpcap")
    end

    args = %W[
      --with-liblua=#{formula_opt_prefix("lua")}
      --with-libpcre=#{formula_opt_prefix("pcre2")}
      --with-openssl=#{formula_opt_prefix("openssl@4")}
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
