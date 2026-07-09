class Minicom < Formula
  desc "Menu-driven communications program"
  homepage "https://packages.debian.org/sid/minicom"
  url "https://deb.debian.org/debian/pool/main/m/minicom/minicom_2.11.1.orig.tar.bz2"
  sha256 "87cf0da91af0531357cd61b8e1906b907edd2c9ef82f9ae74c277e1893d0f98c"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://deb.debian.org/debian/pool/main/m/minicom/"
    regex(/href=.*?minicom[._-]v?(\d+(?:\.\d+)+)\.orig\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "a7ccffde0108b847384bfd1b59b65de15b2fa0038243b4b89929469f9d8e3a31"
    sha256 arm64_sequoia: "c1046b7a4d8540dded35f2d6c758132ca368ff643ace8a43830c93933dde4211"
    sha256 arm64_sonoma:  "40e8ee3f381fd2f7d947d3d225d90a3ae7ad8d57da02a62f17e982c027594ebb"
    sha256 sonoma:        "87c70d667abc34630459c7f77fcb4ccbaf6999c99a0bf41b2c8c64e3fe9cefa2"
    sha256 arm64_linux:   "a0e36a528830ec4e3c82e15d2e33c73cfc58aaf6f4ece7bfe6994f31e48c43dd"
    sha256 x86_64_linux:  "7d3b7a1bfe3f23bc11c7b8b437d0673b6b86363e9c92b39ae5ccfadf164a9737"
  end

  head do
    url "https://salsa.debian.org/minicom-team/minicom.git", branch: "master"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "pkgconf" => :build

  uses_from_macos "ncurses"

  def install
    # There is a silly bug in the Makefile where it forgets to link to iconv. Workaround below.
    ENV["LIBS"] = "-liconv" if OS.mac?

    system "./autogen.sh" if build.head?
    system "./configure", *std_configure_args, "--mandir=#{man}"
    system "make", "install"

    (prefix/"etc").mkdir
    (prefix/"var").mkdir
    (prefix/"etc/minirc.dfl").write "pu lock #{prefix}/var\npu escape-key Escape (Meta)\n"
  end

  def caveats
    <<~EOS
      Terminal Compatibility
      ======================
      If minicom doesn't see the LANG variable, it will try to fallback to
      make the layout more compatible, but uglier. Certain unsupported
      encodings will completely render the UI useless, so if the UI looks
      strange, try setting the following environment variable:

        LANG="en_US.UTF-8"

      Text Input Not Working
      ======================
      Most development boards require Serial port setup -> Hardware Flow
      Control to be set to "No" to input text.
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/minicom -v")
  end
end
