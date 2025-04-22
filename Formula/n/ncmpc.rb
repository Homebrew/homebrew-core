class Ncmpc < Formula
  desc "Curses Music Player Daemon (MPD) client"
  homepage "https://www.musicpd.org/clients/ncmpc/"
  url "https://www.musicpd.org/download/ncmpc/0/ncmpc-0.52.tar.xz"
  sha256 "3af225496fe363a8534a9780fb46ae1bd17baefd80cf4ba7430a19cddd73eb1a"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://www.musicpd.org/download/ncmpc/0/"
    regex(/href=.*?ncmpc[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia: "3e4c3f1696738bc7953a5e066430fabe411a08ac18637c0055237f7fbec8461b"
    sha256 arm64_sonoma:  "e6c82a7bfc8790701e5ae101608cd015c84f18f0a31e007b80ec5b3078555e62"
    sha256 arm64_ventura: "f7c1bf501994b1028ab1fbd9ac4dd4d83c96bb3ab83b25b4ce8cf8f0e8f692fe"
    sha256 sonoma:        "9d2b5eb8ff59ba6b5cf65df8c0106197cdfb69a7970198950e433407087c005b"
    sha256 ventura:       "709d7f29cb41e2e081f09941a33fc2e49f9cb7bd47e9231acf8baf4869106cb0"
    sha256 arm64_linux:   "035d0b5dcd1e9f4847560b81d629c2cb35597521a00fe75ed56cf9ffb171879b"
    sha256 x86_64_linux:  "f47ead26271a682a4c3bff3720dce9a2ef700a80d92123477d7254056c2d1fb3"
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
