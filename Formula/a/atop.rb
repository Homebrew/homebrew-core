class Atop < Formula
  desc "Advanced system and process monitor for Linux using process events"
  homepage "https://www.atoptool.nl"
  url "https://github.com/Atoptool/atop/archive/refs/tags/v2.13.0.tar.gz"
  sha256 "5ee38c93afd64767a09a06698a0e90bfc390189a5058d245878a559d476d8572"
  license "GPL-2.0-or-later"
  head "https://github.com/Atoptool/atop.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_linux:  "79f0e3d6905ef3ad32afd3884550bc1abc65722b4a49dcc1672f5545fe46596b"
    sha256 cellar: :any, x86_64_linux: "362c4b0dd3c636214e20c1b0b74bde7449d4d9a6b4648251b07e7ca1209cbc86"
  end

  depends_on "pkgconf" => :build
  depends_on "glib"
  depends_on :linux
  depends_on "ncurses"
  depends_on "zlib-ng-compat"

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
