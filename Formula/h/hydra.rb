class Hydra < Formula
  desc "Network logon cracker which supports many services"
  homepage "https://github.com/vanhauser-thc/thc-hydra"
  url "https://github.com/vanhauser-thc/thc-hydra/archive/refs/tags/v9.5.tar.gz"
  sha256 "9dd193b011fdb3c52a17b0da61a38a4148ffcad731557696819d4721d1bee76b"
  license "AGPL-3.0-only"
  revision 4
  head "https://github.com/vanhauser-thc/thc-hydra.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "5fde2d1c22b0a5028645283b6692517e0e15d18e1460754dc0cbe7d3918a0874"
    sha256 cellar: :any,                 arm64_sonoma:   "d9af4495a0d5abb4b06610fc318f59cbebe1e2da7add59eb6fc2b9ddbcc64329"
    sha256 cellar: :any,                 arm64_ventura:  "67bc1df2d95effb418e766e7e4c193ce5b52edd2c8afe39e026b369aa839baa9"
    sha256 cellar: :any,                 arm64_monterey: "dee157bd05914bb135e8d441e1e8046407041988a7efd9b6c95895305662f951"
    sha256 cellar: :any,                 sonoma:         "d899e3a522e8a1b5354298b87f439753cd840582e52492f66831ed2749c5f270"
    sha256 cellar: :any,                 ventura:        "bd32c29f4788e9b9f815cfa35ddfaf2b07abb060f306c0896353922e0cc6f112"
    sha256 cellar: :any,                 monterey:       "92398562b54c347d26d4d14f0b01839af9fba7ea382dcc3142b37a77ba30a018"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9844343bce3a35c77ac050dd02a30f765921e0f5b69cc04d9fd62e0d4f49116b"
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
    assert_match(/ mysql .* ssh /, shell_output(bin/"hydra", 255))
  end
end
