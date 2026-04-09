class Ettercap < Formula
  desc "Multipurpose sniffer/interceptor/logger for switched LAN"
  homepage "https://ettercap.github.io/ettercap/"
  url "https://github.com/Ettercap/ettercap/archive/refs/tags/v0.8.4.1.tar.gz"
  sha256 "210a535138772ee67f5946ef61efe3bba31413d0f241a11d953fb553cacbbacd"
  license "GPL-2.0-or-later"
  head "https://github.com/Ettercap/ettercap.git", branch: "master"

  bottle do
    sha256 arm64_tahoe:   "683a1e70a4ed420180dc80604f60bc2f1862f0f37db7fd315c6ed0a98c427ea2"
    sha256 arm64_sequoia: "4d89d3266fc1456c361809c437ddd63efbd2b22f4f843cb7f6a0930cce0e418c"
    sha256 arm64_sonoma:  "57b7ba0a951d2d150bc15e4c550dea9d72d8b8185950b9ad8771c16f23bde0be"
    sha256 sonoma:        "71e45b355ab2fcd63cfd1d50797908832d2d0a75a6da4b68076eaf8e1b671d0b"
    sha256 arm64_linux:   "8b73234cc878c74b1c948428238c7d5db228d4c445f25bb732b657ca8853e7ff"
    sha256 x86_64_linux:  "5c052b9cfffeb2a6ab032ff9903575894dadefc364b8dcb1090d28d34ec4648c"
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
