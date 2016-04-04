class Lnav < Formula
  desc "Curses-based tool for viewing and analyzing log files"
  homepage "http://lnav.org"
  url "https://github.com/tstack/lnav/releases/download/v0.8.0/lnav-0.8.0.tar.gz"
  sha256 "fbebe3f4656c89b307fe06e7746e6146ae856048413a7cd98aaf8fc2bb34fc33"

  bottle do
    revision 1
    sha256 "d34926a00d4aca2e8045ddbe12b948042b2dfa262e403b67f303cfb01c7af482" => :el_capitan
    sha256 "ab14e46f5a4c0570a3437ae1703ec152e86d57e5a47192d3f81d74665e74649d" => :yosemite
    sha256 "819ca781ef7c4e2d2ba2caa314a691ad72f7255489f13a36333e1faf49fc08e8" => :mavericks
  end

  head do
    url "https://github.com/tstack/lnav.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "re2c" => :build
  end

  depends_on "readline"
  depends_on "pcre"
  depends_on "curl" => ["with-libssh2", :optional]

  def install
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --with-readline=#{Formula["readline"].opt_prefix}
    ]

    if build.with? "curl"
      # Specify the cURL binary path, so that the configure script
      # can look up the correct compile time flags.
      ENV.prepend_path "PATH", "#{Formula["curl"].bin}"

      # cURL depends on libssh2, due to the 'with-libssh2' flag, which in turn
      # depends on libcrypto and libssl. These are neither specified by the
      # lnav configure scripts, nor curl-config binary.
      ENV.append "LIBS", "-lcrypto -lssl"

      # OS X ships with libcurl by default, albeit without sftp support. If we
      # want lnav to use the keg-only cURL formula that we specify as a
      # dependency, we need to pass in the path.
      args << "--with-libcurl=#{Formula["curl"].opt_prefix}"
    end

    system "./autogen.sh" if build.head?
    system "./configure", *args
    system "make", "install"
  end
end
