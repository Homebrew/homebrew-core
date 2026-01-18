class Ettercap < Formula
  desc "Multipurpose sniffer/interceptor/logger for switched LAN"
  homepage "https://ettercap.github.io/ettercap/"
  license "GPL-2.0-or-later"
  revision 2
  head "https://github.com/Ettercap/ettercap.git", branch: "master"

  stable do
    url "https://github.com/Ettercap/ettercap/archive/refs/tags/v0.8.3.1.tar.gz"
    sha256 "d0c3ef88dfc284b61d3d5b64d946c1160fd04276b448519c1ae4438a9cdffaf3"

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
      url "https://raw.githubusercontent.com/Homebrew/homebrew-core/1cf441a0/Patches/ettercap/libmaxminddb-backport.diff"
      sha256 "b7869963df256af7cfae0f9e936e6dac4ec51a8b38dcfef6ea909e81e3ab8d0e"
    end

    # Apply Debian's upstreamed patch for pcre2 support. Remove in the next release.
    # https://github.com/Ettercap/ettercap/commit/b1686d46792aecc10662e4a8ec221c9727661878
    patch do
      url "https://sources.debian.org/data/main/e/ettercap/1%3A0.8.3.1-15/debian/patches/1170.patch"
      sha256 "a3c426d36f84487bbdb5d02b831df295af33373fcb59ee81254cee6807a50a4c"
    end
  end

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 2
    sha256 arm64_tahoe:   "2244ce8f708f9889ff92f8861bbae03a92aac0a2cf7457bc0b334301f4bff2bd"
    sha256 arm64_sequoia: "6d98587a5e98e2db83bf85117ea496c15f114fab7d702459811591af756f3c7c"
    sha256 arm64_sonoma:  "a72d69fae20cd902444c9aed9ac7c2b34861319ffc2847b0ea2d23723bb8c181"
    sha256 sonoma:        "9c04bde58b1776e853b1b9092899d28d90270907cd644d889db1fc00f32f18d3"
    sha256 arm64_linux:   "8f7f88b2aa5083456ebaa7694d2ddafb83c46d0d8fad766e2ea4e583e3e0ffa0"
    sha256 x86_64_linux:  "e825ecc7c84a08331974048d31b39125c15c8d8d44d002744be0686a000a3b4a"
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
  uses_from_macos "zlib"

  on_macos do
    # Use ninja to work around build failure with make:
    # .../tapi stubify -isysroot ... -o libettercap-ui.0.8.3.1.tbd libettercap-ui.0.8.3.1.dylib
    # error: no such file or directory: 'libettercap-ui.0.8.3.1.dylib'
    depends_on "ninja" => :build

    depends_on "at-spi2-core"
    depends_on "cairo"
    depends_on "freetype"
    depends_on "pango"
  end

  def install
    (buildpath/"share").install resource("GeoLite2-Country.mmdb") if build.stable?

    # Work around a CMake bug affecting harfbuzz headers and pango
    # https://gitlab.kitware.com/cmake/cmake/issues/19531
    ENV.append_to_cflags "-I#{Formula["harfbuzz"].opt_include}/harfbuzz"

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
