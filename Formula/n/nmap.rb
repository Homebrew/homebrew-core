class Nmap < Formula
  desc "Port scanning utility for large networks"
  homepage "https://nmap.org/"
  url "https://nmap.org/dist/nmap-7.97.tar.bz2"
  sha256 "af98f27925c670c257dd96a9ddf2724e06cb79b2fd1e0d08c9206316be1645c0"
  license :cannot_represent
  head "https://svn.nmap.org/nmap/"

  livecheck do
    url "https://nmap.org/download"
    regex(/href=.*?nmap[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia: "3248afca88a66d1c05d45184e3ad392d621d0840f7e8cd4414fd9f3dbbc1269b"
    sha256 arm64_sonoma:  "7016aa0e4002533b53fba111768bc68213f3ea657addb03322a84b0dab9c7808"
    sha256 arm64_ventura: "a65b39e2ab437dce905172ef2d4a76d163d642b480b64517294ee870cea89e9a"
    sha256 sonoma:        "5bb32d46f1eb4d1e6dbe2660e5f0638effa1b71c88afb94bf245cda37cd12008"
    sha256 ventura:       "2a903ba2f7c273438c76f983d0ef047b9777372e29f4323f8fc1891e8873b3bc"
    sha256 arm64_linux:   "679376aa9188cb49e1b789871c84341ed312c66ab3491be3a1aad245a7357070"
    sha256 x86_64_linux:  "55ff270118c5f7228041f2b8adc141ed004e860400e1f6980e9ed5b08814bca1"
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

    bin.glob("uninstall_*").map(&:unlink) # Users should use brew uninstall.
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
