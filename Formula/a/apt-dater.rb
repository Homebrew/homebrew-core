class AptDater < Formula
  desc "Manage package updates on remote hosts using SSH"
  homepage "https://github.com/DE-IBH/apt-dater"
  url "https://github.com/DE-IBH/apt-dater/archive/refs/tags/v1.0.4.tar.gz"
  sha256 "a4bd5f70a199b844a34a3b4c4677ea56780c055db7c557ff5bd8f2772378a4d6"
  license "GPL-2.0-or-later"
  revision 1
  version_scheme 1

  bottle do
    rebuild 1
    sha256 arm64_sequoia:  "e89784e139fbbe28d5b78275b2242171bac80c2ef9499613154b3e7811c08468"
    sha256 arm64_sonoma:   "2f391ec78361caf2e94d1e63cc21f0b1f00939ada71065b215e41f798025018f"
    sha256 arm64_ventura:  "c22ae498b3b9ffaa679ccf61ce23dc2938d2acd6960db44c422269c2673cab2a"
    sha256 arm64_monterey: "fe34f1009b1e42d85afbcbbae7c61554e6ebe527112d8249430f896661c82817"
    sha256 sonoma:         "34b892275adfc73fe17bd925f2cf7a29b9f02d29c84dca818b46a1d9e5faf6ac"
    sha256 ventura:        "bdd43755453bb7b579382091ce430bc9d16bb8fbf128ece766b92034ff547963"
    sha256 monterey:       "3bcfbb9b3f6648f528de329d439840049cabfcb55d81757eebb74f3da88e7ad3"
    sha256 arm64_linux:    "b80fdf17b885b19e6c905fd64524968669f4cd80aed8119526377ad774c3c62b"
    sha256 x86_64_linux:   "0aa11ef9c978a52cc0b1941bd4484df092e4dd1c0682f616692b30bc894feb85"
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
  end

  def install
    ENV.prepend_path "PATH", Formula["coreutils"].libexec/"gnubin" if OS.mac?
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
