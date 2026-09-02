class Nmap < Formula
  desc "Port scanning utility for large networks"
  homepage "https://nmap.org/"
  url "https://nmap.org/dist/nmap-7.991.tar.bz2"
  sha256 "a5d507f29437bef3bedd4771ff9aaa8fc1c2a109ddba1f5b1cf12027456929be"
  license :cannot_represent
  compatibility_version 1
  head "https://svn.nmap.org/nmap/"

  livecheck do
    url "https://nmap.org/download"
    regex(/href=.*?nmap[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "7b44210db7bec422a6db3551c6ce37c032d549c6e4b7c1fc73dfc3fd84ffcb61"
    sha256 arm64_sequoia: "53af60fb8bc2a54c94d48522bec7b90c8de5843e1057203e56d5ed922ee05f5e"
    sha256 arm64_sonoma:  "7f1314efd3f78af8cebad0f254de7c4a8d0b1f4f0e881f99f64bbc42d184d9aa"
    sha256 sonoma:        "8e0cf28019b8f08cd0c861743fce47446e11197a1c0dd4fa5e6d930ef5c0c78a"
    sha256 arm64_linux:   "1d20106da65dabc3c10921eac6666505c2433cc4d9646fefc4cfa6a2403fb547"
    sha256 x86_64_linux:  "d3f0b702152aaba2e73585a51352ec2143ca9f1870f1849058de81fdfed7a116"
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

  deny_network_access!

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
      --with-openssl=#{formula_opt_prefix("openssl@3")}
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
