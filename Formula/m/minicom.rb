class Minicom < Formula
  desc "Menu-driven communications program"
  homepage "https://packages.debian.org/sid/minicom"
  url "https://deb.debian.org/debian/pool/main/m/minicom/minicom_2.9.orig.tar.bz2"
  sha256 "9efbb6458140e5a0de445613f0e76bcf12cbf7a9892b2f53e075c2e7beaba86c"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://deb.debian.org/debian/pool/main/m/minicom/"
    regex(/href=.*?minicom[._-]v?(\d+(?:\.\d+)+)\.orig\.t/i)
  end

  bottle do
    sha256 arm64_sequoia:  "3fffa1688f76eecf53156914c4e793b55bc98ec39ef9d1012dd71e6d036ef959"
    sha256 arm64_sonoma:   "b92b70950bd1142625c5a91bb815cc6b5a6e302bac3d2deb2ba6a27346275a82"
    sha256 arm64_ventura:  "c0027370447eb9cfb68179a1d27bbecc4a0682351b454da5dd563f0641f6d9e1"
    sha256 arm64_monterey: "3ffb59047f0ddedd946f3396ff160438b6d7642824f5a1a63a1d2d37e3aa9c6e"
    sha256 sonoma:         "dfaaf1a7d3ed1c5fa8478c15daf7b0a730187fb8272df248051a32e4ca734030"
    sha256 ventura:        "afd820441655a587192dedb3e38563fd57b899efdeee1c306e785cc0ff706fb9"
    sha256 monterey:       "37884d21fe67fb95c0b637a98d6fdd969c4a98bacda9a4724f3d32e0639d6df3"
    sha256 x86_64_linux:   "8d7abc35dc2a14d94619c4ee3d81812e94bb9287eb23455b4f1cb686680f558d"
  end

  head do
    url "https://salsa.debian.org/minicom-team/minicom.git", branch: "master"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

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
