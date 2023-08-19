class Hydra < Formula
  desc "Network logon cracker which supports many services"
  homepage "https://github.com/vanhauser-thc/thc-hydra"
  url "https://github.com/vanhauser-thc/thc-hydra/archive/v9.5.tar.gz"
  sha256 "9dd193b011fdb3c52a17b0da61a38a4148ffcad731557696819d4721d1bee76b"
  license "AGPL-3.0-only"
  revision 2
  head "https://github.com/vanhauser-thc/thc-hydra.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4dd1a40a47a6d21db024a3fa9c9c538c46f2e6a19b7db8b7443977b87b8baf76"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e1d8c51d8f1768fa1b4f88b90cbdc792f59387e59562a1a9d057a2a4bcba0541"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a5b0056b050593dc17211890362fa09c1bd52d889fd142736b7b4c1114bb5e05"
    sha256 cellar: :any_skip_relocation, ventura:        "fdd37885440ef848dfc7030e67c281262b5b5b5e4139372f40a91f894b28f256"
    sha256 cellar: :any_skip_relocation, monterey:       "073cd2c90a68bdeb9c2108e84bdb18dc1caf8c2b924f7466d868288edc6ef929"
    sha256 cellar: :any_skip_relocation, big_sur:        "4d411dcdc73070bdc6c01b458ba694717b8a9970a21ddcc75d4ab7c87611015c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c8b19d859564f0dc079b0e81717f6d747028b0837b2cb277dd0df9d017836b0d"
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
