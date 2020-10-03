class Nmap < Formula
  desc "Port scanning utility for large networks"
  homepage "https://nmap.org/"
  url "https://nmap.org/dist/nmap-7.90.tar.bz2"
  sha256 "5557c3458275e8c43e1d0cfa5dad4e71dd39e091e2029a293891ad54098a40e8"
  head "https://svn.nmap.org/nmap/"

  livecheck do
    url "https://nmap.org/dist/"
    regex(/href=.*?nmap[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

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
