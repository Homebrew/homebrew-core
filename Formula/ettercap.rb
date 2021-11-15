class Ettercap < Formula
  desc "Multipurpose sniffer/interceptor/logger for switched LAN"
  homepage "https://ettercap.github.io/ettercap/"
  url "https://github.com/Ettercap/ettercap/archive/v0.8.3.1.tar.gz"
  sha256 "d0c3ef88dfc284b61d3d5b64d946c1160fd04276b448519c1ae4438a9cdffaf3"
  license "GPL-2.0-or-later"
  head "https://github.com/Ettercap/ettercap.git"

  bottle do
    rebuild 1
    sha256 arm64_monterey: "03b8f22c58c172d1e8f649d789eec2c92ba1b742f12c1681005a023b5ae6395f"
    sha256 arm64_big_sur:  "9e53f689acd75a9aa32129e3aa3d81af5f799889ed3144adb3e867c6f2470369"
    sha256 monterey:       "ae97b65299092b6419c2786553381188d3303d7c4dd12d1c34d08042ccbae017"
    sha256 big_sur:        "471e0a6f6fb68103bc56ccf90b873cd86c235c34e88972828b6ba69dd2fd9f44"
    sha256 catalina:       "e52f75a8579926652f5c53ef77db1eeab39f0ff388ad77fbbe70a17a52554c2b"
    sha256 mojave:         "c49b5293922b69715b05c1bc1374cec3cfe72a63750ab0fb08d559683d253afc"
    sha256 high_sierra:    "3ab1aa27eef60cb9099bdd95ca330c0fd63dad10c169c968672bb44d97ae32e1"
    sha256 x86_64_linux:   "58d95c7e206ac3c4f3ccb46f8427b40e63b70bf068239211a1e15656244a0b85"
  end

  depends_on "cmake" => :build
  depends_on "geoip"
  depends_on "gtk+3"
  depends_on "libnet"
  depends_on "ncurses" if DevelopmentTools.clang_build_version >= 1000
  depends_on "openssl@1.1"
  depends_on "pcre"

  uses_from_macos "curl"
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
