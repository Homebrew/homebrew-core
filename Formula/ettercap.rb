class Ettercap < Formula
  desc "Multipurpose sniffer/interceptor/logger for switched LAN"
  homepage "https://ettercap.github.io/ettercap/"
  license "GPL-2.0-or-later"
  revision 1
  head "https://github.com/Ettercap/ettercap.git", branch: "master"

  stable do
    url "https://github.com/Ettercap/ettercap/archive/v0.8.3.1.tar.gz"
    sha256 "d0c3ef88dfc284b61d3d5b64d946c1160fd04276b448519c1ae4438a9cdffaf3"

    # Fix build for curl 8+
    # https://github.com/Ettercap/ettercap/pull/1221
    patch do
      url "https://github.com/Ettercap/ettercap/commit/40534662043b7d831d1f6c70448afa9d374a9b63.patch?full_index=1"
      sha256 "ac9edbd2f5d2e809835f8b111a7f20000ffab0efca2d6f17f4b199bb325009b1"
    end
  end

  bottle do
    sha256 arm64_ventura:  "d05ff28b40d013049ecd4561053b6109380b3ac508d8569238cd14daf5dc34bb"
    sha256 arm64_monterey: "1ee92f370378dcbdeba399e2c5dee7505bc99d607adc9bd7a6a60198c688973f"
    sha256 arm64_big_sur:  "30ca037f9002b6848905612870fd5e1697dfcce1362408c032376c4c0646e957"
    sha256 ventura:        "37664fbe01b8878e9ea3ebe5eff196e20fe4ab66dff3717c3e1ac60026e9ab8a"
    sha256 monterey:       "35d3bc9c62448f484d4689845ad5644e752486e70aecba0bc1a40bd63d68a052"
    sha256 big_sur:        "a9f6669b6a8374a1c2ef82237bb4ca25419550cce6a18098776b355a8223cbbb"
    sha256 x86_64_linux:   "6e7f045902aadfd09135dfeb6937876c1932b42505baafb7a5c8d9f9f355bb6e"
  end

  depends_on "cmake" => :build
  depends_on "geoip"
  depends_on "gtk+3"
  depends_on "libnet"
  depends_on "ncurses" if DevelopmentTools.clang_build_version >= 1000
  depends_on "openssl@3"
  depends_on "pcre"

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build
  uses_from_macos "curl"
  uses_from_macos "libpcap"
  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  def install
    # Work around a CMake bug affecting harfbuzz headers and pango
    # https://gitlab.kitware.com/cmake/cmake/issues/19531
    ENV.append_to_cflags "-I#{Formula["harfbuzz"].opt_include}/harfbuzz"

    args = %W[
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

    if OS.linux?
      # Fix build error on wdg_file.c: fatal error: menu.h: No such file or directory
      ENV.append_to_cflags "-I#{Formula["ncurses"].opt_include}/ncursesw"
      args << "-DPOLKIT_DIR=#{share}/polkit-1/actions/"
    end

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ettercap --version")
  end
end
