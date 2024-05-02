class Ettercap < Formula
  desc "Multipurpose sniffer/interceptor/logger for switched LAN"
  homepage "https://ettercap.github.io/ettercap/"
  license "GPL-2.0-or-later"
  revision 2

  stable do
    url "https://github.com/Ettercap/ettercap/archive/refs/tags/v0.8.3.1.tar.gz"
    sha256 "d0c3ef88dfc284b61d3d5b64d946c1160fd04276b448519c1ae4438a9cdffaf3"

    depends_on "pcre"

    # Part of libmaxminddb backport that cannot be added via patch.
    # Remove in the next release along with corresponding install
    resource "GeoLite2-Country.mmdb" do
      url "https://raw.githubusercontent.com/Ettercap/ettercap/741c4d3bcd5c3e37d7d6b0fe0e748a955b2f43f5/share/GeoLite2-Country.mmdb"
      sha256 "b22fd1cc9bd76c0706ed6cafefcd07c2bfb5a22581faebdcd9161b9d8a44d0c0"
    end

    # Fix build for curl 8+
    # https://github.com/Ettercap/ettercap/pull/1221
    patch do
      url "https://github.com/Ettercap/ettercap/commit/40534662043b7d831d1f6c70448afa9d374a9b63.patch?full_index=1"
      sha256 "ac9edbd2f5d2e809835f8b111a7f20000ffab0efca2d6f17f4b199bb325009b1"
    end

    # Backport libmaxminddb support. Remove in the next release.
    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/1857153707716e38c40ebb5dc641a30a471e2962/ettercap/libmaxminddb-backport.diff"
      sha256 "b7869963df256af7cfae0f9e936e6dac4ec51a8b38dcfef6ea909e81e3ab8d0e"
    end
  end

  bottle do
    rebuild 1
    sha256 arm64_sonoma:   "314023a2a65ca174dd90a8e777a0ce694ee24619e419e893a8f3d8a82b004935"
    sha256 arm64_ventura:  "59f3ecc8f33ff3a865e2b608b8969f8d31e77c8aa82218707cecf21ce466bf60"
    sha256 arm64_monterey: "ad36dab4532384d39be0e58ce0752b499bfae8cce41c317d6748479707e416d1"
    sha256 sonoma:         "197cbb987473cb58c67447cd85f104762640df66e2e24f8ab6366539dc3fa087"
    sha256 ventura:        "385d806561cfbb2513e6b0bb3b487312eaba6e5bdbcfffb36f6004a53f1348e8"
    sha256 monterey:       "e09c5c23e3f73b224dd8d6be74ca8b80bf24989eaaa786b102d82f2979fda47e"
    sha256 x86_64_linux:   "ed90068515d35787a0e19066936f3689eea7a1e7ed85ab1119ab60a71c7881d6"
  end

  head do
    url "https://github.com/Ettercap/ettercap.git", branch: "master"

    depends_on "pcre2"
  end

  depends_on "cmake" => :build
  depends_on "gtk+3"
  depends_on "libmaxminddb"
  depends_on "libnet"
  depends_on "ncurses" if DevelopmentTools.clang_build_version >= 1000
  depends_on "openssl@3"

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build
  uses_from_macos "curl"
  uses_from_macos "libpcap"
  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  on_macos do
    # Use ninja to work around build failure with make:
    # .../tapi stubify -isysroot ... -o libettercap-ui.0.8.3.1.tbd libettercap-ui.0.8.3.1.dylib
    # error: no such file or directory: 'libettercap-ui.0.8.3.1.dylib'
    depends_on "ninja" => :build
  end

  def install
    (buildpath/"share").install resource("GeoLite2-Country.mmdb") if build.stable?

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
    else
      args << "-GNinja"
    end

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ettercap --version")
  end
end
