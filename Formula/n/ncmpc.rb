class Ncmpc < Formula
  desc "Curses Music Player Daemon (MPD) client"
  homepage "https://www.musicpd.org/clients/ncmpc/"
  url "https://www.musicpd.org/download/ncmpc/0/ncmpc-0.51.tar.xz"
  sha256 "e74be00e69bc3ed1268cafcc87274e78dfbde147f2480ab0aad8260881ec7271"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://www.musicpd.org/download/ncmpc/0/"
    regex(/href=.*?ncmpc[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia: "068010e9a68c7d84e1f13932f9dd4adf3d28b0ff95044b30d6c3fe4740134a20"
    sha256 arm64_sonoma:  "2437913591f67d021d4b1f54c5f93922ec4d104d6f209b4c3736e574e4e4c23b"
    sha256 arm64_ventura: "f747b415b0fb6a890d55de13a7aeb311ce5900cca982acea9b944762746a786f"
    sha256 sonoma:        "ceaa62c8a78fe27663c8bb10ac84ede19dd234d907374b15ae768b5011671d43"
    sha256 ventura:       "4038a0781b9b7344d336e603e87c3e2ccb11e2ed295731258e626fe7e7d53432"
    sha256 x86_64_linux:  "3b17830a4d437b28793131d0d2c1a7a62f78fc630c745ca3446391c3bfd905bb"
  end

  depends_on "boost" => :build
  depends_on "gettext" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build

  depends_on "fmt"
  depends_on "libmpdclient"
  depends_on "pcre2"

  uses_from_macos "ncurses"

  on_macos do
    depends_on "gettext"
    depends_on "llvm" if DevelopmentTools.clang_build_version <= 1500
  end

  fails_with :clang do
    build 1500
    cause "Requires C++20"
  end

  fails_with :gcc do
    version "9"
    cause "Requires C++20"
  end

  def install
    if OS.mac? && (DevelopmentTools.clang_build_version <= 1500)
      ENV.llvm_clang
      # Work around failure mixing newer `llvm` headers with older Xcode's libc++:
      # Undefined symbols for architecture arm64:
      #   "std::exception_ptr::__from_native_exception_pointer(void*)", referenced from:
      #       std::exception_ptr std::make_exception_ptr[abi:ne180100]<std::runtime_error>(std::runtime_error) ...
      ENV.prepend_path "HOMEBREW_LIBRARY_PATHS", Formula["llvm"].opt_lib/"c++"
    end

    system "meson", "setup", "build", "-Dcolors=false", "-Dnls=enabled", "-Dregex=enabled", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    assert_match "Key configuration screen", shell_output("#{bin}/ncmpc --dump-keys")
    assert_match version.to_s, shell_output("#{bin}/ncmpc --version")
  end
end
