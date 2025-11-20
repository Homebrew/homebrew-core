class Ncmpc < Formula
  desc "Curses Music Player Daemon (MPD) client"
  homepage "https://www.musicpd.org/clients/ncmpc/"
  url "https://www.musicpd.org/download/ncmpc/0/ncmpc-0.52.tar.xz"
  sha256 "3af225496fe363a8534a9780fb46ae1bd17baefd80cf4ba7430a19cddd73eb1a"
  license "GPL-2.0-or-later"
  revision 1

  livecheck do
    url "https://www.musicpd.org/download/ncmpc/0/"
    regex(/href=.*?ncmpc[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "79925b06f7a4619e7e1e062db3ce4cac42646b6e3152de52554cad995969cbe1"
    sha256 arm64_sequoia: "0f280c690e83b4c4d4cb20aca9084c5bbcafb8046ac0c90b524f001ca4a45fcf"
    sha256 arm64_sonoma:  "4047ec4992db95e0b22057f9164dfcbbf69104d765674f62d5acb502e56c61e2"
    sha256 sonoma:        "57f3acdb57163d256a7470b702b6630cf79585c84822cfc6b1d10784c18a8fcc"
    sha256 arm64_linux:   "40bc8c01c1dfcd01f160e9ee0286225a681ebcf2962a47d820137d54a5bc50c8"
    sha256 x86_64_linux:  "8244e48ef47afc6f03c012409429e6fd1c2c8631a53a197d31b0df9ac88a7628"
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

    # Fixes: error: use of undeclared identifier 'strcoll_l'
    patch do
      url "https://github.com/MusicPlayerDaemon/ncmpc/commit/af478b5ba2447592c640c5b7f86c47d9a412c639.patch?full_index=1"
      sha256 "193f6c3192ba39974a2f1ef4935c623d58e0614f9978b2e6545c6231fd5ffdb5"
    end
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
