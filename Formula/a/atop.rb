class Atop < Formula
  desc "Advanced system and process monitor for Linux using process events"
  homepage "https://www.atoptool.nl"
  url "https://github.com/Atoptool/atop/archive/refs/tags/v2.11.1.tar.gz"
  sha256 "72b39a6f9afd917cf6b92e544b28e9a65942da1b97bdee4ca7eafeea9d169a76"
  license "GPL-2.0-or-later"
  head "https://github.com/Atoptool/atop.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_linux:  "8e9f07f76fd12d19988646ce63af2569a594f8dc63feecb73f3e2c18615d6c48"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "d52b4a792db5bd610cdbd776da9cb33f092734d0250b4d43f7116567605ba516"
  end

  depends_on "pkgconf" => :build
  depends_on "glib"
  depends_on :linux
  depends_on "linux-headers@5.15"
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
