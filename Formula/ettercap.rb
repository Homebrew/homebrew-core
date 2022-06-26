class Ettercap < Formula
  desc "Multipurpose sniffer/interceptor/logger for switched LAN"
  homepage "https://ettercap.github.io/ettercap/"
  url "https://github.com/Ettercap/ettercap/archive/v0.8.3.1.tar.gz"
  sha256 "d0c3ef88dfc284b61d3d5b64d946c1160fd04276b448519c1ae4438a9cdffaf3"
  license "GPL-2.0-or-later"
  head "https://github.com/Ettercap/ettercap.git", branch: "master"

  bottle do
    rebuild 2
    sha256 arm64_monterey: "a8532b43e6d6c1bed08ae62506ad32d75bbd39da7c7fcdfde1cbcf758717b932"
    sha256 arm64_big_sur:  "581fbb637481f46c59b355f5bbde58a2d25da7e3f22ec9e07edab8f3a6c54999"
    sha256 monterey:       "46f9eae5abfe8bb43e56cb0d333de5304911229b003e19fd495a5394383ce340"
    sha256 big_sur:        "bc9dd754581b99d9f86a98e6ac5844fe41ba0ac017cc16086c39168efc2f1859"
    sha256 catalina:       "a131e2c7a6d1360ce74ed8f91abe43b92f2b1bcf843bfcddca8bef01dea97c6f"
    sha256 x86_64_linux:   "46e8ef6cfe822480232a0218a1d563086bb6df3cf4f7c71fa1edad9cde0bbf9f"
  end

  depends_on "cmake" => :build
  depends_on "geoip"
  depends_on "gtk+3"
  depends_on "libnet"
  depends_on "ncurses" if DevelopmentTools.clang_build_version >= 1000
  depends_on "openssl@1.1"
  depends_on "pcre"

  uses_from_macos "curl"
  uses_from_macos "flex"
  uses_from_macos "libpcap"
  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  def install
    # Work around a CMake bug affecting harfbuzz headers and pango
    # https://gitlab.kitware.com/cmake/cmake/issues/19531
    ENV.append_to_cflags "-I#{Formula["harfbuzz"].opt_include}/harfbuzz"

    # Fix build error on wdg_file.c: fatal error: menu.h: No such file or directory
    ENV.append_to_cflags "-I#{Formula["ncurses"].opt_include}/ncursesw" if OS.linux?

    args = std_cmake_args + %W[
      -DBUNDLED_LIBS=OFF
      -DCMAKE_INSTALL_RPATH=#{rpath}
      -DENABLE_CURSES=ON
      -DENABLE_GTK=ON
      -DENABLE_IPV6=ON
      -DENABLE_LUA=OFF
      -DENABLE_PDF_DOCS=OFF
      -DENABLE_PLUGINS=ON
      -DGTK_BUILD_TYPE=GTK3
      -DGTK3_GLIBCONFIG_INCLUDE_DIR=#{Formula["glib"].opt_lib}/glib-2.0/include
      -DINSTALL_DESKTOP=ON
      -DINSTALL_SYSCONFDIR=#{etc}
    ]
    args << "-DPOLKIT_DIR=#{share}/polkit-1/actions/" if OS.linux?

    mkdir "build" do
      system "cmake", "..", *args
      system "make", "install"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ettercap --version")
  end
end
