class Ettercap < Formula
  desc "Multipurpose sniffer/interceptor/logger for switched LAN"
  homepage "https://ettercap.github.io/ettercap/"
  url "https://github.com/Ettercap/ettercap/archive/refs/tags/v0.8.5.1.tar.gz"
  sha256 "66a25a7581fc1a0d72d3c96794ee540a2555738a95eb09dd32ee3dad4f8f8d7f"
  license "GPL-2.0-or-later"
  head "https://github.com/Ettercap/ettercap.git", branch: "master"

  bottle do
    sha256 arm64_golden_gate: "96c259dbd324973ff853076684ba7b31ca7da7292356a2e694b368051908e902"
    sha256 arm64_tahoe:       "ee8d2ac198de80ae8b6275317777b18bb1979c77cc18f01a6bbbd1ff8f98eaca"
    sha256 arm64_sequoia:     "45ce9f91a10a5cdc37e8bdbe0290dbcb75380905e2ae9538341d881679bf933c"
    sha256 arm64_linux:       "f7362bf12188a7f319c6d6e7931cabfc1c5c3d17697bf5dc6bb6840805a1a1e6"
    sha256 x86_64_linux:      "03fec1b76d93572778d5d1a1becc6cba46f0b549ccf2dd66ff476b1e9dc66577"
  end

  depends_on "cmake" => :build
  depends_on "gdk-pixbuf"
  depends_on "glib"
  depends_on "gtk+3"
  depends_on "libmaxminddb"
  depends_on "libnet"
  depends_on "ncurses"
  depends_on "openssl@4"
  depends_on "pcre2"

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build
  uses_from_macos "curl"
  uses_from_macos "libpcap"

  on_macos do
    depends_on "at-spi2-core"
    depends_on "cairo"
    depends_on "freetype"
    depends_on "pango"
  end

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    args = %W[
      -DBUNDLED_LIBS=OFF
      -DCMAKE_INSTALL_RPATH=#{rpath};#{rpath(source: lib/"ettercap")}
      -DCMAKE_POLICY_VERSION_MINIMUM=3.5
      -DENABLE_CURSES=ON
      -DENABLE_GTK=ON
      -DENABLE_IPV6=ON
      -DENABLE_LUA=OFF
      -DENABLE_PDF_DOCS=OFF
      -DENABLE_PLUGINS=ON
      -DGTK_BUILD_TYPE=GTK3
      -DGTK3_GLIBCONFIG_INCLUDE_DIR=#{formula_opt_lib("glib")}/glib-2.0/include
      -DINSTALL_DESKTOP=ON
      -DINSTALL_SYSCONFDIR=#{etc}
    ]

    if OS.linux?
      # Fix build error on wdg_file.c: fatal error: menu.h: No such file or directory
      ENV.append_to_cflags "-I#{formula_opt_include("ncurses")}/ncursesw"
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
