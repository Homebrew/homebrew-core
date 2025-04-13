class Hydra < Formula
  desc "Network logon cracker which supports many services"
  homepage "https://github.com/vanhauser-thc/thc-hydra"
  url "https://github.com/vanhauser-thc/thc-hydra/archive/refs/tags/v9.5.tar.gz"
  sha256 "9dd193b011fdb3c52a17b0da61a38a4148ffcad731557696819d4721d1bee76b"
  license "AGPL-3.0-only"
  revision 5
  head "https://github.com/vanhauser-thc/thc-hydra.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "4f52a4dd8c6ee9b1819f64a688cd7f2677873250a515b2269acac1758bafc1c8"
    sha256 cellar: :any,                 arm64_sonoma:  "3ecca5dbd9fc6e4770e0c302cb183b65b9eb107ed4a49bea7991905e7635cdaa"
    sha256 cellar: :any,                 arm64_ventura: "ddfa012421a719f0299339726f34303ac70cfc84bb8be9f60faee15c9c670ac2"
    sha256 cellar: :any,                 sonoma:        "8e7d6db10c76332a98db7be88357089ad50d984fa057382f1513aaed157f1bfd"
    sha256 cellar: :any,                 ventura:       "0cf381bd263ece00b7174f9cf025055616688e77774bf9c9bf7a298a0876a33d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3d8c55399e4bbb56fb9e2f50f99f894d7d729582cdc53e8cd2682f0593928f80"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b289ab00cf96e4b7a327102991a0d1787756dcdca1af594828c05ecc4e86e075"
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
