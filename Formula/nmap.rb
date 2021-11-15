class Nmap < Formula
  desc "Port scanning utility for large networks"
  homepage "https://nmap.org/"
  url "https://nmap.org/dist/nmap-7.92.tar.bz2"
  sha256 "a5479f2f8a6b0b2516767d2f7189c386c1dc858d997167d7ec5cfc798c7571a1"
  license :cannot_represent
  head "https://svn.nmap.org/nmap/"

  livecheck do
    url "https://nmap.org/dist/"
    regex(/href=.*?nmap[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "fce671325c40cb243af6e19672b1a09221973211483c80641f0f698670d38b06"
    sha256 arm64_big_sur:  "1f40f19d97c6f87564344793e9921535137f0d76020132cd33fff9a5b9e220da"
    sha256 monterey:       "aed665169bd13d61b5b4cb04204548d6012cfe4bffe4ae40a44a86f756ffc64e"
    sha256 big_sur:        "0e98a05d4ff5630ab1e70218930c06e598164fb5832fb76b3e4df3a4b6872ffa"
    sha256 catalina:       "fe638eedb2063e9bdd8fb75679c6bceead8084456bba2a43819889c93158301d"
    sha256 mojave:         "dba8ca74eccbb2eec127b82d6cb81478c131ba3d19f7851b82871775bb01e8b3"
    sha256 x86_64_linux:   "5ceab0e20f0aba5059b7ba612876413c799d0a933dfb46c5bf078b432d01c7dd"
  end

  depends_on "openssl@1.1"

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build
  uses_from_macos "zlib"

  conflicts_with "ndiff", because: "both install `ndiff` binaries"

  def install
    ENV.deparallelize

    args = %W[
      --prefix=#{prefix}
      --with-libpcre=included
      --with-liblua=included
      --with-openssl=#{Formula["openssl@1.1"].opt_prefix}
      --without-nmap-update
      --disable-universal
      --without-zenmap
    ]

    system "./configure", *args
    system "make" # separate steps required otherwise the build fails
    system "make", "install"

    rm_f Dir[bin/"uninstall_*"] # Users should use brew uninstall.
  end

  test do
    system "#{bin}/nmap", "-p80,443", "google.com"
  end
end
