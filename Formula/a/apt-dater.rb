class AptDater < Formula
  desc "Manage package updates on remote hosts using SSH"
  homepage "https://github.com/DE-IBH/apt-dater"
  url "https://github.com/DE-IBH/apt-dater/archive/refs/tags/v1.0.4.tar.gz"
  sha256 "a4bd5f70a199b844a34a3b4c4677ea56780c055db7c557ff5bd8f2772378a4d6"
  license "GPL-2.0-or-later"
  revision 3
  version_scheme 1

  bottle do
    sha256 arm64_golden_gate: "891972799330621928a01277fcfbfb5dbbfde4b2825284f7bb4d389a1e3f3386"
    sha256 arm64_tahoe:       "54ac1e581d1005ad7972864ffd240a906e3e4cc3fc3cb1a6167979cf86e02c9a"
    sha256 arm64_sequoia:     "eb9414457f5422b5be9d3faa106b312c63ce4ab50214557eb51ac2778274da54"
    sha256 arm64_linux:       "4d0be167796c7fabc5022c52d30ab755f5fe551b59a66d42fdd7c223bfc6cbe3"
    sha256 x86_64_linux:      "4f00af46531a1318929f7a344207ce4aba4233e8d0a3b52f4c41e66d95784693"
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
