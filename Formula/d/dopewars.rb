class Dopewars < Formula
  desc 'Free rewrite of a game originally based on "Drug Wars"'
  homepage "https://dopewars.sourceforge.io"
  url "https://downloads.sourceforge.net/project/dopewars/dopewars/1.7.0/dopewars-1.7.0.tar.gz"
  sha256 "106dfea6a019b00b69a26044c82d6977296c0c7c684c0c9c256a04ed8adfb20f"
  license "GPL-2.0-or-later"

  bottle do
    sha256 arm64_golden_gate: "9124b36e81ce76fead891d1ef8e21b4a72909286e66000a8d16083418d7b0c10"
    sha256 arm64_tahoe:       "32b1b72f03015a87d1f859a9f739ca8cb9918f8cfae668d1de4317cbef5bc626"
    sha256 arm64_sequoia:     "8aeafadcc264e12349d8a85fd5f4524a2345b5802397878b5e8c8f83fe7b4692"
    sha256 arm64_linux:       "1a76b9b191b543f432b549f9aa3182bfdbf67039c683b9c445050cea53752ff5"
    sha256 x86_64_linux:      "cb1cc09dd5cefd70012cb61dbb6020331dcd627fd23f15ea03c145a84e7f303d"
  end

  depends_on "pkgconf" => :build

  depends_on "glib"

  uses_from_macos "curl"
  uses_from_macos "ncurses"

  on_macos do
    depends_on "gettext"
  end

  deny_network_access!

  def install
    inreplace "src/Makefile.in", "chmod", "true"
    inreplace "auxbuild/ltmain.sh", "need_relink=yes", "need_relink=no"
    inreplace "src/plugins/Makefile.in", "LIBADD =", "LIBADD = -module -avoid-version"

    system "./configure", "--disable-gui-client",
                          "--disable-gui-server",
                          "--enable-plugins",
                          "--enable-networking",
                          "--mandir=#{man}",
                          *std_configure_args
    system "make", "install", "chgrp=true"
  end

  test do
    system bin/"dopewars", "-v"
  end
end
