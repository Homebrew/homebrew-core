class Nmap < Formula
  desc "Port scanning utility for large networks"
  homepage "https://nmap.org/"
  url "https://nmap.org/dist/nmap-7.80.tar.bz2"
  sha256 "fcfa5a0e42099e12e4bf7a68ebe6fde05553383a682e816a7ec9256ab4773faa"
  license "GPL-2.0"
  revision 1
  head "https://svn.nmap.org/nmap/"

  bottle do
    rebuild 1
    sha256 "e1ba8b92c348e3d04c89f4ffc50800d480dd45ca34726a4f7e3fe7974b0bb651" => :catalina
    sha256 "fb166b6d77a7a1df2a38a58f5123d51bd3ace308c736094c2c9b5a2591f405ee" => :mojave
    sha256 "8edad05b0f4fc20552dd6c1b573a7fa6bf2d03568b014ee60c1153980fb43649" => :high_sierra
  end

  depends_on "openssl@1.1"

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build
  uses_from_macos "zlib"

  conflicts_with "ndiff", because: "both install `ndiff` binaries"

  # Remove for > 7.80
  # Big Sur fix; see also: https://github.com/nmap/nmap/pull/2085
  patch do
    url "https://github.com/nmap/nmap/commit/05763b620d4c92a7fe4afee649f3b317894f5ca6.patch?full_index=1"
    sha256 "3efed6ca33f7a529053c8f913c62966014ebcc1b0ef406fe0c251767e1300d37"
  end

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
