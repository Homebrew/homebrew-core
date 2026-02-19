class Ettercap < Formula
  desc "Multipurpose sniffer/interceptor/logger for switched LAN"
  homepage "https://ettercap.github.io/ettercap/"
  url "https://github.com/Ettercap/ettercap/archive/refs/tags/v0.8.4.tar.gz"
  sha256 "1674c235b16b2048888b85a697697eb0c4e742f875fdaaef7acacc152568ad06"
  license "GPL-2.0-or-later"
  head "https://github.com/Ettercap/ettercap.git", branch: "master"

  bottle do
    rebuild 1
    sha256 arm64_tahoe:   "b0f697c28c4d4dc88b6f717abaf9bf9856b9fa26c2aa511b970dcfcc6ea1105d"
    sha256 arm64_sequoia: "8f56c6044ab1ab45ce0cddf6628aac54ec78a5644ccf3d6da3adf982ead97b70"
    sha256 arm64_sonoma:  "8318020ce63c1709a24a570ea65c9c0c76a6e7391f8a78808c3f6d133620ece5"
    sha256 sonoma:        "3dd8609d57b114735a7db0708b350a5587f4435c4b4b11d1ca20871c5837decf"
    sha256 arm64_linux:   "73a5e485dae3ee5339481f54ae56ccbb69bacc5d41ecbfc8053071be373d9b9a"
    sha256 x86_64_linux:  "98f5d49640400d62f0813d27d2d72c2a68473c28bd621004fd24b5ce13f9fc0a"
  end

  depends_on "cmake" => :build
  depends_on "gdk-pixbuf"
  depends_on "glib"
  depends_on "gtk+3"
  depends_on "libmaxminddb"
  depends_on "libnet"
  depends_on "ncurses"
  depends_on "openssl@3"
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
