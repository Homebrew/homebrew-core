class Hydra < Formula
  desc "Network logon cracker which supports many services"
  homepage "https://github.com/vanhauser-thc/thc-hydra"
  url "https://github.com/vanhauser-thc/thc-hydra/archive/refs/tags/v9.6.tar.gz"
  sha256 "c839e5c64ef60185c69a07a9a59831bd2cfe9ac2eac0c4d9e87fdf38dbf04c40"
  license "AGPL-3.0-only"
  head "https://github.com/vanhauser-thc/thc-hydra.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "1da116ec3e9e0c199532be9dab820da943fd90882a26c4299e5784783b680af2"
    sha256 cellar: :any,                 arm64_sequoia: "59462731671d23a67a26c61731967a0997cf97be55b47241bb7bc8773315d5b7"
    sha256 cellar: :any,                 arm64_sonoma:  "1587d19830a37949d7997933c8c2e0aabaef9d13ff054e588ae2c0461fd1b15b"
    sha256 cellar: :any,                 arm64_ventura: "e9ec5262f77f8f099f7d1fcf0a4c35d8cc66f71af7dd9629f4b662dfb4bbe125"
    sha256 cellar: :any,                 sonoma:        "32ae8946b3891da2b56df93f7de828243be8498ddbca4e4a20b3864c9f052dd4"
    sha256 cellar: :any,                 ventura:       "7ce1e368623e1a98fa4594879774604d871b56eedea4127c4bdafb59369e1e8c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "564ffb41b6e522fd8a13fc3ae634aa888144c66216198a96dd81d61ee2ba6205"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e062f5c8583970cd8fff70e7f4ae8ead1b2514c8e4d0fac47422990aa21940ae"
  end

  depends_on "pkgconf" => :build
  depends_on "libssh"
  depends_on "mariadb-connector-c"
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
      s.gsub!(/^MYSQL_PATH=""$/, "MYSQL_PATH=#{Formula["mariadb-connector-c"].opt_lib}")
      s.gsub!(/^MYSQL_IPATH=""$/, "MYSQL_IPATH=#{Formula["mariadb-connector-c"].opt_include}/mariadb")
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
    assert_match(/ mysql .* ssh /, shell_output(bin/"hydra", 255))
  end
end
