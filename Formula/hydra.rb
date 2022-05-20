class Hydra < Formula
  desc "Network logon cracker which supports many services"
  homepage "https://github.com/vanhauser-thc/thc-hydra"
  url "https://github.com/vanhauser-thc/thc-hydra/archive/v9.3.tar.gz"
  sha256 "3977221a7eb176cd100298c6d47939999a920a628868ae1aceed408a21e04013"
  license "AGPL-3.0-only"
  head "https://github.com/vanhauser-thc/thc-hydra.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "d81667ed28dc2b8e38d9f44d7fd8b3aecd71a48f2f49d3005c7054872b96612a"
    sha256 cellar: :any,                 arm64_big_sur:  "0b040b93fa5d82aea9d0158eb74e291c6cc4f7fd4c8071f96b2ab0d2324ad28b"
    sha256 cellar: :any,                 monterey:       "08c11395c5eb20f807d57083e39472bc2408d0861aabbdf3c23cb35b15754d45"
    sha256 cellar: :any,                 big_sur:        "f9de22a865bfa3e8f71d958b95b656c253e1c6af5f40576f6667a08f604ce0e3"
    sha256 cellar: :any,                 catalina:       "d5bc777635381242e8c03a33cbf1da3eaf63c1abd88922e0be2075b35d93108d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "36cdb072b8118f86cc077be2d7c862e46f847f23e65fbc192968845b4c9fe8ad"
  end

  depends_on "pkg-config" => :build
  depends_on "libssh"
  depends_on "mysql-client"
  depends_on "openssl@1.1"
  depends_on "pcre"
  uses_from_macos "ncurses"

  conflicts_with "ory-hydra", because: "both install `hydra` binaries"

  # Fix "non-void function 'add_header' should return a value", issue introduced in version 9.3
  # Patch accepted upstream, remove on next release
  patch do
    url "https://github.com/vanhauser-thc/thc-hydra/commit/e5996654ed48b385bc7f842d84d8b2ba72d29be1.patch?full_index=1"
    sha256 "146827f84a20a8e26e28118430c3400f23e7ca429eff62d0664e900aede207cc"
  end

  def install
    inreplace "configure" do |s|
      # Link against our OpenSSL
      # https://github.com/vanhauser-thc/thc-hydra/issues/80
      s.gsub!(/^SSL_PATH=""$/, "SSL_PATH=#{Formula["openssl@1.1"].opt_lib}")
      s.gsub!(/^SSL_IPATH=""$/, "SSL_IPATH=#{Formula["openssl@1.1"].opt_include}")
      s.gsub!(/^SSLNEW=""$/, "SSLNEW=YES")
      s.gsub!(/^CRYPTO_PATH=""$/, "CRYPTO_PATH=#{Formula["openssl@1.1"].opt_lib}")
      s.gsub!(/^SSH_PATH=""$/, "SSH_PATH=#{Formula["libssh"].opt_lib}")
      s.gsub!(/^SSH_IPATH=""$/, "SSH_IPATH=#{Formula["libssh"].opt_include}")
      s.gsub!(/^MYSQL_PATH=""$/, "MYSQL_PATH=#{Formula["mysql-client"].opt_lib}")
      s.gsub!(/^MYSQL_IPATH=""$/, "MYSQL_IPATH=#{Formula["mysql-client"].opt_include}/mysql")
      s.gsub!(/^PCRE_PATH=""$/, "PCRE_PATH=#{Formula["pcre"].opt_lib}")
      s.gsub!(/^PCRE_IPATH=""$/, "PCRE_IPATH=#{Formula["pcre"].opt_include}")
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
