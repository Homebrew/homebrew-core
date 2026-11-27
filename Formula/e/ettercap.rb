class Ettercap < Formula
  desc "Multipurpose sniffer/interceptor/logger for switched LAN"
  homepage "https://ettercap.github.io/ettercap/"
  url "https://github.com/Ettercap/ettercap/archive/refs/tags/v0.8.5.2.tar.gz"
  sha256 "748f91ae3b4d4eaf4fecd220542796b8be19589221c53f68c7a3c72c1a3222ab"
  license "GPL-2.0-or-later"
  head "https://github.com/Ettercap/ettercap.git", branch: "master"

  bottle do
    manifest_sha256 "77e3227c385a0cf329b4a2c78bb9a2ede9ac720a6df47c71a58c67c4e61b462a"
    sha256 arm64_golden_gate: "94fde49a647d5c290599892ea329d1ce027a5de8f0049f3641e0dd10d972a423"
    sha256 arm64_tahoe:       "ccc5a8a01f77738e5083c53a540526fe129dd8644bb7ad20ead42cdd3884daca"
    sha256 arm64_sequoia:     "d76c6e32c35b21507fc465279b7d3abaefa2bc99a2747996f2b1370650b05199"
    sha256 arm64_linux:       "a461ca5058e660930a9b1dd144710af95cb0b6f7b9a0bfca5a1bbe2211b0baa9"
    sha256 x86_64_linux:      "5dd76aac647750eafe85d3876d077159102044171d1d3f36270fc16bb8a0f649"
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

  deny_network_access!

  def install
    plugin_rpath = rpath(source: lib/"ettercap")
    args = %W[
      -DBUNDLED_LIBS=OFF
      -DCMAKE_INSTALL_RPATH=#{rpath};#{plugin_rpath}
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
