class Hydra < Formula
  desc "Network logon cracker which supports many services"
  homepage "https://github.com/vanhauser-thc/thc-hydra"
  url "https://github.com/vanhauser-thc/thc-hydra/archive/v9.5.tar.gz"
  sha256 "9dd193b011fdb3c52a17b0da61a38a4148ffcad731557696819d4721d1bee76b"
  license "AGPL-3.0-only"
  revision 1
  head "https://github.com/vanhauser-thc/thc-hydra.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "4233b96be61ab5a51cc06ce000551cdda2930b9908520c4431e7f8a6778fc08c"
    sha256 cellar: :any,                 arm64_monterey: "d6027630cf3aaa8c88dcb70e0d4f8cb202a1eab7b8b2ad348ff4c60753fcf457"
    sha256 cellar: :any,                 arm64_big_sur:  "fc87e1cf552aafa0b3948c475b2a2ea5a89feb39572393f80ff17db9623c5e8c"
    sha256 cellar: :any,                 ventura:        "7166d64116322a253217a1363c32838ff3003d3d2ab70299a9b89e6503278a35"
    sha256 cellar: :any,                 monterey:       "6a3c2fce671fa1b2ae2ce7291f9300d180ed1595176d6fc7d7c8cbc67530081e"
    sha256 cellar: :any,                 big_sur:        "d0dce2ce89065f3026e5e07bfd3935e17b4e4e21357a03d77806766bef2766e1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aa4a0a0ba72ad73ea3d23e84bef1ff6ecb0a88ea3c307c8997a6c9f95af9aa2b"
  end

  depends_on "pkg-config" => :build
  depends_on "libssh"
  depends_on "mysql-client"
  depends_on "openssl@3"
  depends_on "pcre2"
  uses_from_macos "ncurses"

  conflicts_with "ory-hydra", because: "both install `hydra` binaries"

  def install
    inreplace "configure" do |s|
      # Link against our OpenSSL
      # https://github.com/vanhauser-thc/thc-hydra/issues/80
      s.gsub!(/^SSL_PATH=""$/, "SSL_PATH=#{Formula["openssl@3"].opt_lib}")
      s.gsub!(/^SSL_IPATH=""$/, "SSL_IPATH=#{Formula["openssl@3"].opt_include}")
      s.gsub!(/^SSLNEW=""$/, "SSLNEW=YES")
      s.gsub!(/^CRYPTO_PATH=""$/, "CRYPTO_PATH=#{Formula["openssl@3"].opt_lib}")
      s.gsub!(/^SSH_PATH=""$/, "SSH_PATH=#{Formula["libssh"].opt_lib}")
      s.gsub!(/^SSH_IPATH=""$/, "SSH_IPATH=#{Formula["libssh"].opt_include}")
      s.gsub!(/^MYSQL_PATH=""$/, "MYSQL_PATH=#{Formula["mysql-client"].opt_lib}")
      s.gsub!(/^MYSQL_IPATH=""$/, "MYSQL_IPATH=#{Formula["mysql-client"].opt_include}/mysql")
      s.gsub!(/^PCRE_PATH=""$/, "PCRE_PATH=#{Formula["pcre2"].opt_lib}")
      s.gsub!(/^PCRE_IPATH=""$/, "PCRE_IPATH=#{Formula["pcre2"].opt_include}")
      if OS.mac?
        s.gsub!(/^CURSES_PATH=""$/, "CURSES_PATH=#{MacOS.sdk_path_if_needed}/usr/lib")
        s.gsub!(/^CURSES_IPATH=""$/, "CURSES_IPATH=#{MacOS.sdk_path_if_needed}/usr/include")
      else
        s.gsub!(/^CURSES_PATH=""$/, "CURSES_PATH=#{Formula["ncurses"].opt_lib}")
        s.gsub!(/^CURSES_IPATH=""$/, "CURSES_IPATH=#{Formula["ncurses"].opt_include}")
      end
      # Avoid opportunistic linking of everything
      %w[
        gtk+-2.0
        libfreerdp2
        libgcrypt
        libidn
        libmemcached
        libmongoc
        libpq
        libsvn
      ].each do |lib|
        s.gsub! lib, "oh_no_you_dont"
      end
    end

    # Having our gcc in the PATH first can cause issues. Monitor this.
    # https://github.com/vanhauser-thc/thc-hydra/issues/22
    system "./configure", "--prefix=#{prefix}"
    bin.mkpath
    system "make", "all", "install"
    share.install prefix/"man" # Put man pages in correct place
  end

  test do
    assert_match(/ mysql .* ssh /, shell_output("#{bin}/hydra", 255))
  end
end
