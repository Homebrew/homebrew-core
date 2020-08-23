class Ettercap < Formula
  desc "Multipurpose sniffer/interceptor/logger for switched LAN"
  homepage "https://ettercap.github.io/ettercap/"
  url "https://github.com/Ettercap/ettercap/archive/v0.8.3.tar.gz"
  sha256 "d561a554562e447f4d7387a9878ba745e1aa8c4690cc4e9faaa779cfdaa61fbb"
  license "GPL-2.0"
  revision 4
  head "https://github.com/Ettercap/ettercap.git"

  bottle do
    sha256 "bf0ff6a7811739607b89238cf506127b07f778a9324ec29c26ef653eb1f0308a" => :catalina
    sha256 "49f51aa40ed1a82102bcdaeb5255de50f3f0683cb7f17606b7a4c8ea49fc1aa2" => :mojave
    sha256 "63b7e5b4c73d5f4606bf98d5e4b11a8231c2aa700cbfd4b832c75a405e7ed69b" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "geoip"
  depends_on "gtk+3"
  depends_on "libnet"
  depends_on "ncurses" if DevelopmentTools.clang_build_version >= 1000
  depends_on "openssl@1.1"
  depends_on "pcre"

  def install
    # Work around a CMake bug affecting harfbuzz headers and pango
    # https://gitlab.kitware.com/cmake/cmake/issues/19531
    ENV.append_to_cflags "-I#{Formula["harfbuzz"].opt_include}/harfbuzz"

    args = std_cmake_args + %W[
      -DBUNDLED_LIBS=OFF
      -DENABLE_CURSES=ON
      -DENABLE_GTK=ON
      -DENABLE_IPV6=ON
      -DENABLE_LUA=OFF
      -DENABLE_PDF_DOCS=OFF
      -DENABLE_PLUGINS=ON
      -DGTK_BUILD_TYPE=GTK3
      -DINSTALL_DESKTOP=ON
      -DINSTALL_SYSCONFDIR=#{etc}
    ]

    mkdir "build" do
      system "cmake", "..", *args
      system "make", "install"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ettercap --version")
  end
end
