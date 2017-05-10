class Ettercap < Formula
  desc "Multipurpose sniffer/interceptor/logger for switched LAN"
  homepage "https://ettercap.github.io/ettercap/"
  revision 1

  head "https://github.com/Ettercap/ettercap.git"

  stable do
    url "https://github.com/Ettercap/ettercap/archive/v0.8.2.tar.gz"
    sha256 "f38514f35bea58bfe6ef1902bfd4761de0379942a9aa3e175fc9348f4eef2c81"

    # Fixes CVE-2017-6430.
    patch do
      url "https://github.com/Ettercap/ettercap/commit/4ad7f85d.patch"
      sha256 "a53322b8f103d92e3947b947083e548a92e05c0c2814ee870ec21a31eb0035c3"
    end
  end

  bottle do
    rebuild 2
    sha256 "4f2e62c67e6e445378dfc8647a45e988a3ec967b40bd2b1647205f34b2fa7ebd" => :sierra
    sha256 "65ea7526addde2a4a53a3148c056e12514481394e4c9e2d04f79edf0fb3b9c58" => :el_capitan
    sha256 "90cb2fbbd2d792293aad154f293f8d2c8b486b6478c3087ad8657005f3e1d1cd" => :yosemite
    sha256 "6f11280ec2f3d7e6b89663ced4fd4d0051a5e35b335108a56561dab6e8728257" => :mavericks
  end

  option "without-curses", "Install without curses interface"
  option "without-plugins", "Install without plugins support"
  option "without-ipv6", "Install without IPv6 support"

  depends_on "cmake" => :build
  depends_on "ghostscript" => [:build, :optional]
  depends_on "pcre"
  depends_on "libnet"
  depends_on "openssl"
  depends_on "curl" if MacOS.version <= :mountain_lion # requires >= 7.26.0.
  depends_on "gtk+" => :optional
  depends_on "gtk+3" => :optional
  depends_on "luajit" => :optional

  def install
    args = std_cmake_args + %W[
      -DBUNDLED_LIBS=OFF
      -DINSTALL_SYSCONFDIR=#{etc}
    ]

    if build.with? "curses"
      args << "-DENABLE_CURSES=ON"
    else
      args << "-DENABLE_CURSES=OFF"
    end

    if build.with? "plugins"
      args << "-DENABLE_PLUGINS=ON"
    else
      args << "-DENABLE_PLUGINS=OFF"
    end

    if build.with? "ipv6"
      args << "-DENABLE_IPV6=ON"
    else
      args << "-DENABLE_IPV6=OFF"
    end

    if build.with? "ghostscript"
      args << "-DENABLE_PDF_DOCS=ON"
    else
      args << "-DENABLE_PDF_DOCS=OFF"
    end

    if build.with?("gtk+") || build.with?("gtk+3")
      args << "-DENABLE_GTK=ON" << "-DINSTALL_DESKTOP=ON"
      args << "-DGTK_BUILD_TYPE=GTK3" if build.with? "gtk+3"
    else
      args << "-DENABLE_GTK=OFF" << "-DINSTALL_DESKTOP=OFF"
    end

    if build.with? "luajit"
      args << "-DENABLE_LUA=ON"
    else
      args << "-DENABLE_LUA=OFF"
    end

    mkdir "build" do
      system "cmake", "..", *args
      system "make", "install"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ettercap --version")
  end
end
