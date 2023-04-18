class Hydra < Formula
  desc "Network logon cracker which supports many services"
  homepage "https://github.com/vanhauser-thc/thc-hydra"
  url "https://github.com/vanhauser-thc/thc-hydra/archive/v9.4.tar.gz"
  sha256 "c906e2dd959da7ea192861bc4bccddfed9bc1799826f7600255f57160fd765f8"
  license "AGPL-3.0-only"
  head "https://github.com/vanhauser-thc/thc-hydra.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "637217ccfe6c7d1e52784ad6f2b1503e93fcb31fe9aba8cbc926c5d8f1d5daf0"
    sha256 cellar: :any,                 arm64_monterey: "6c76b09ffc546df4bab7824046c8d94217f3f634c2df00aafe488f4d4e8474f8"
    sha256 cellar: :any,                 arm64_big_sur:  "1cefde616d5eed48679e20dbd7159784904eddb175503216ddbb07dcb64f4e87"
    sha256 cellar: :any,                 ventura:        "cb2307c3b37e16b4b66a3cef11d8e2047b037c41db4eed4b1e64a460bcef58cd"
    sha256 cellar: :any,                 monterey:       "151d5a41a45193154a178726b54c2d23b1a3f4ec2837db9b90d2d6ed078aaca7"
    sha256 cellar: :any,                 big_sur:        "8b4aaaf394f78719f98023f0ef840a4d6c47c5cf02a209c368b4648eed627c8c"
    sha256 cellar: :any,                 catalina:       "9fc26bf7f2ffdd333595d9b5b18d199ea5146b43b79e50859be316ef1a4b57f3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cf7f3d55d430cd0decc4ab9cfd4b194f15d49c3276fadd8027f908634c5dc366"
  end

  depends_on "pkg-config" => :build
  depends_on "libssh"
  depends_on "mysql-client"
  depends_on "openssl@1.1"
  depends_on "pcre2"
  uses_from_macos "ncurses"

  conflicts_with "ory-hydra", because: "both install `hydra` binaries"

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
