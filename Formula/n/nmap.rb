class Nmap < Formula
  desc "Port scanning utility for large networks"
  homepage "https://nmap.org/"
  url "https://nmap.org/dist/nmap-7.95.tar.bz2"
  sha256 "e14ab530e47b5afd88f1c8a2bac7f89cd8fe6b478e22d255c5b9bddb7a1c5778"
  license :cannot_represent
  revision 1
  head "https://svn.nmap.org/nmap/"

  livecheck do
    url "https://nmap.org/download"
    regex(/href=.*?nmap[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 arm64_sequoia: "50ff67cd6a9106fd4813f23563e93afb1c010e72d2440210547ab1e85a9a2f8b"
    sha256 arm64_sonoma:  "903b327e4d5670592fce8006045465c25f4906860124a6fadd09c8c6f075173d"
    sha256 arm64_ventura: "ea8100a4be7170fc892f4b07ae93c6a783cdf4b73637f8bc6b77e70e1a3da9e2"
    sha256 sonoma:        "29886e3599134f930e515d864133d5560ca4fa6688683d6d6651a3e74659bd1e"
    sha256 ventura:       "7960ae55e221cd465ec9c81bab21c68e3deba12a42ba54a062b5a7357d8aedf2"
    sha256 arm64_linux:   "ba802ad8db113e38cb97d0052043909b48fe830ba6ba4fd5ff17dedfd3a5b564"
    sha256 x86_64_linux:  "6d61d459f9d25a07da0695b7c6be96392fcb8f662babb6bedb64b371575da6d5"
  end

  depends_on "liblinear"
  depends_on "libssh2"
  # Check supported Lua version at https://github.com/nmap/nmap/tree/master/liblua.
  depends_on "lua"
  depends_on "openssl@3"
  depends_on "pcre2"

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build
  uses_from_macos "libpcap"
  uses_from_macos "zlib"

  conflicts_with "cern-ndiff", "ndiff", because: "both install `ndiff` binaries"
  conflicts_with "nping", because: "both install `nping` binaries"
  conflicts_with cask: "zenmap", because: "both install `nmap` binaries"

  def install
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
    ]

    system "./configure", *args, *std_configure_args
    system "make" # separate steps required otherwise the build fails
    system "make", "install"

    bin.glob("uninstall_*").map(&:unlink) # Users should use brew uninstall.
    return unless (bin/"ndiff").exist? # Needs Python

    # We can't use `rewrite_shebang` here because `detected_python_shebang` only works
    # for shebangs that start with `/usr/bin`, but the shebang we want to replace
    # might start with `/Applications` (for the `python3` inside Xcode.app).
    inreplace bin/"ndiff", %r{\A#!.*/python(\d+(\.\d+)?)?$}, "#!/usr/bin/env python3"
  end

  def caveats
    on_macos do
      <<~EOS
        If using `ndiff` returns an error about not being able to import the ndiff module, try:
          chmod go-w #{HOMEBREW_CELLAR}
      EOS
    end
  end

  test do
    system bin/"nmap", "-p80,443", "google.com"
  end
end
