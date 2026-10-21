class Ettercap < Formula
  desc "Multipurpose sniffer/interceptor/logger for switched LAN"
  homepage "https://ettercap.github.io/ettercap/"
  url "https://github.com/Ettercap/ettercap/archive/refs/tags/v0.8.4.1.tar.gz"
  sha256 "210a535138772ee67f5946ef61efe3bba31413d0f241a11d953fb553cacbbacd"
  license "GPL-2.0-or-later"
  revision 1
  head "https://github.com/Ettercap/ettercap.git", branch: "master"

  bottle do
    sha256 arm64_golden_gate: "2067bebeff7ee6a107aa74a0319a297fb4f2a3f8427a804c425f268fcd3edbc5"
    sha256 arm64_tahoe:       "1ce97459f932492aaf8639b7ca222b1fb3d250e2fbb1689562c30bd8023f4657"
    sha256 arm64_sequoia:     "bd07cbd1265e4ce88e9e583c26ad9732a0806637ec3ceec57091ef9c887292c2"
    sha256 arm64_linux:       "8b84982eb7c34ff667976e87c21044d67438d259f5d9646352da8195136dc741"
    sha256 x86_64_linux:      "0fb808262825f92f2ff4bee730fdcb19f4311606357cdca277d31dbf5c1fe4eb"
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
