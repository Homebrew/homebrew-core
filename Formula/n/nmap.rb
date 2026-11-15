class Nmap < Formula
  desc "Port scanning utility for large networks"
  homepage "https://nmap.org/"
  url "https://nmap.org/dist/nmap-7.993.tar.bz2"
  sha256 "270e55f04915bfcecb5db8feb959d4c5ba86a48c094520a4f1c07571e1c79c59"
  license :cannot_represent
  compatibility_version 1

  livecheck do
    url "https://nmap.org/download"
    regex(/href=.*?nmap[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_golden_gate: "224b7bc076c6dc0f138c257625c4d8ac29d13f35b5f03bf49adc2677617e9970"
    sha256 arm64_tahoe:       "d73f46bc48f88239668916175d56817240f6e8673b1411b55560d9e9828dc067"
    sha256 arm64_sequoia:     "8f09090b946adaf527925c0a837250fc791166fbc5263e21774a067cb5079ce6"
    sha256 arm64_linux:       "f18f36e19b5254ba6a2c92b0f701319d0d9043c706763382763fc681fb20b637"
    sha256 x86_64_linux:      "8d0587a88a10f7fee0d7f73716116003e1fbbe85ed9e440f0cee9b7b8bf782ed"
  end

  head do
    url "https://svn.nmap.org/nmap/"

    depends_on "autoconf" => :build
  end

  depends_on "python-setuptools" => :build
  depends_on "liblinear"
  depends_on "libssh2"
  # Check supported Lua version at https://github.com/nmap/nmap/tree/master/liblua.
  depends_on "lua"
  depends_on "openssl@4"
  depends_on "pcre2"
  depends_on "python@3.15" # for ndiff

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

    libpcap_path = OS.mac? ? MacOS.sdk_path/"usr/" : formula_opt_prefix("libpcap")

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
    system python3, "-m", "pip", "install", *std_pip_args, "./ndiff"
    bin.glob("uninstall_*").map(&:unlink) # Users should use brew uninstall.
  end

  test do
    system bin/"nmap", "-p80,443", "-oX", "scan1.xml", "google.com"
    cp "scan1.xml", "scan2.xml"
    system bin/"ndiff", "scan1.xml", "scan2.xml"
  end
end
