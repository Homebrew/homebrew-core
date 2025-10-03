class Atop < Formula
  desc "Advanced system and process monitor for Linux using process events"
  homepage "https://www.atoptool.nl"
  url "https://github.com/Atoptool/atop/archive/refs/tags/v2.12.1.tar.gz"
  sha256 "0f49f3aa5e3449f8c1cf10ac08036e2b67887640fe7980b8bc6ca9fd84d46fdf"
  license "GPL-2.0-or-later"
  head "https://github.com/Atoptool/atop.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_linux:  "5f581fbfafeb966617a05c78b80229de58345210b34b21775324cb7bd4555dbd"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "07279f97d6dbaa37555fdc2ef63686834132d85f12a975515fc7df0538734450"
  end

  depends_on "pkgconf" => :build
  depends_on "glib"
  depends_on :linux
  depends_on "ncurses"
  depends_on "zlib"

  def install
    inreplace "version.h", /"$/, "-#{Utils.git_short_head}\"", global: false if build.head?
    # As this project does not use configure, we have to configure manually:
    ENV["BINPATH"] = bin.to_s
    ENV["SBINPATH"] = bin.to_s
    ENV["MAN1PATH"] = man1.to_s
    ENV["MAN5PATH"] = man5.to_s
    ENV["MAN8PATH"] = man8.to_s
    ENV["DEFPATH"] = "prev"
    ENV["LOGPATH"] = "prev"
    # It would try to install some files suid, which is not good for users:
    inreplace "Makefile", "chmod", "true"
    # RPM and Debian packages do not use the Makefile for users, but it ensures we forget nothing:
    system "make", "-e", "genericinstall"
  end

  test do
    assert_match "Version:", shell_output("#{bin}/atop -V")
    system bin/"atop", "1", "1"
    system bin/"atop", "-w", "atop.raw", "1", "1"
    system bin/"atop", "-r", "atop.raw", "-PCPU,DSK"
  end
end
