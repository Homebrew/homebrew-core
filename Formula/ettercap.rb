class Ettercap < Formula
  desc "Multipurpose sniffer/interceptor/logger for switched LAN"
  homepage "https://ettercap.github.io/ettercap/"
  url "https://github.com/Ettercap/ettercap/archive/v0.8.3.tar.gz"
  sha256 "d561a554562e447f4d7387a9878ba745e1aa8c4690cc4e9faaa779cfdaa61fbb"
  revision 1
  head "https://github.com/Ettercap/ettercap.git"

  bottle do
    sha256 "6b9223005c3270eebfe5f6f7b92d3eade297d9dd7751956f0ead1e880d599b5c" => :mojave
    sha256 "26115281af5357176c502705fe6a9a2a0812e9a1b15c1985cf9fdd5628f46e68" => :high_sierra
    sha256 "74a3396cd202c79e1d4ab227f17d403b72cdca7a6c7fe77f148bb673a9b0094e" => :sierra
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
