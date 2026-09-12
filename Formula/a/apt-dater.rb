class AptDater < Formula
  desc "Manage package updates on remote hosts using SSH"
  homepage "https://github.com/DE-IBH/apt-dater"
  url "https://github.com/DE-IBH/apt-dater/archive/refs/tags/v1.0.4.tar.gz"
  sha256 "a4bd5f70a199b844a34a3b4c4677ea56780c055db7c557ff5bd8f2772378a4d6"
  license "GPL-2.0-or-later"
  revision 3
  version_scheme 1

  bottle do
    sha256 arm64_tahoe:   "ca8d65020e488e692c5785619fda1d960a49f88b2f80e2213f1d56f39b6f40de"
    sha256 arm64_sequoia: "e9a104010e991369030ef2f6b060658977e33252724fb5a1891a69242a8c3fc8"
    sha256 arm64_sonoma:  "cd11a9f62b4e94d1909c0f60bb5a30703d5558e5572b583ccf92ff235e055503"
    sha256 sonoma:        "ad40cadf8e75368960e13f510c8e91977ff13908150431a50066bbab0dfd521b"
    sha256 arm64_linux:   "8aaa2fb5be47e7037a24f2b6bfc14fac79eabf28187a11d5c949db515b34b4a9"
    sha256 x86_64_linux:  "b68bb3ff46e775c78d4201392f44d95e8e28aacdce0dd624469f5bfe6a839557"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "gettext" => :build
  depends_on "pkgconf" => :build
  depends_on "glib"
  depends_on "popt"

  uses_from_macos "libxml2"
  uses_from_macos "ncurses"

  on_macos do
    depends_on "coreutils" => :build # for `date -d`
    depends_on "gettext"
  end

  # Fix incorrect args to g_strlcpy
  # Part of open PR: https://github.com/DE-IBH/apt-dater/pull/182
  patch do
    url "https://github.com/DE-IBH/apt-dater/commit/70a6e4a007d2bbd891442794080ab4fe713a6f94.patch?full_index=1"
    sha256 "de100e8ddd576957e7e2ac6cb5ac43e55235c4031efd7ee6fd0e0e81b7b0b2f4"
    type :backport
  end

  # Fix: AM_GNU_GETTEXT without 'external' argument is no longer supported in version 0.23.1
  # Merged upstream in https://github.com/DE-IBH/apt-dater/pull/180
  patch do
    url "https://github.com/DE-IBH/apt-dater/commit/2e4668f3c1990db30c10fcf30a1501425abce3eb.patch?full_index=1"
    sha256 "05e966c4277970545d226ad2aeae89fd6264e32ff06598a7c02c928227ff714b"
    type :backport
  end

  def install
    ENV.prepend_path "PATH", formula_opt_libexec("coreutils")/"gnubin" if OS.mac?

    # Fix build with C23 compilers. Backport of upstream fix, adjusted to apply cleanly on current release
    # https://github.com/DE-IBH/apt-dater/commit/5392d749a4d09dc0da35d963e6005986492cb5f4
    inreplace "src/sighandler.c", "static RETSIGTYPE sigtermSigHandler()",
                                  "static RETSIGTYPE sigtermSigHandler(int signo)"

    system "autoreconf", "--force", "--install", "--verbose"
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make", "install"
    # Global config overrides local config, so delete global config to prioritize the
    # config in $HOME/.config/apt-dater
    rm_r(prefix/"etc")
  end

  test do
    system bin/"apt-dater", "-v"
  end
end
