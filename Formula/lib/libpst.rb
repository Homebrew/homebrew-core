class Libpst < Formula
  desc "Utilities for the PST file format"
  homepage "https://www.five-ten-sg.com/libpst/"
  url "https://www.five-ten-sg.com/libpst/packages/libpst-0.6.76.tar.gz"
  sha256 "3d291beebbdb48d2b934608bc06195b641da63d2a8f5e0d386f2e9d6d05a0b42"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://www.five-ten-sg.com/libpst/packages/"
    regex(/href=.*?libpst[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "fd7349c417348d0e83213928612500c662ae584e15e66310898c9f49118d6a40"
    sha256 cellar: :any,                 arm64_sequoia: "63fc62578e7c74252237139627caedb3bd86c4b7f6ae9d9573a01acb9361f6bd"
    sha256 cellar: :any,                 arm64_sonoma:  "ddacad786eff967d07cd66cba650cffc04ccfaad18a1e751ff64a7a4014eb87d"
    sha256 cellar: :any,                 sonoma:        "a40ac01b3554f6f3cb978fccff5c6a9d0a1bf58e6bf7031988b93b02e2886b5d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0e1781e796d88004b7ec5ed47a6955a434711a8eaabab2289693f6507788889c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ea909a3fa65389eb8a332f741bd5a948ed7cb006f597d0ecf3c6e46f07d991ad"
  end

  depends_on "pkgconf" => :build

  depends_on "glib"
  depends_on "libgsf"

  on_macos do
    depends_on "gettext"
  end

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "./configure", "--disable-python", *std_configure_args
    system "make", "install"
  end

  test do
    system bin/"lspst", "-V"
  end
end
