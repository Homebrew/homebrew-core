class Procps < Formula
  desc "Utilities for browsing procfs"
  homepage "https://gitlab.com/procps-ng/procps"
  url "https://gitlab.com/procps-ng/procps/-/archive/v4.0.1/procps-v4.0.1.tar.gz"
  sha256 "1eaff353306aba12816d14881f2b88c7c9d06023825f7224700f0c01f66c65cd"
  license "GPL-2.0-or-later"
  head "https://gitlab.com/procps-ng/procps.git", branch: "master"

  bottle do
    sha256 x86_64_linux: "efab0532e0905c46e47f2e5ea9ac3cc413eba0b5a3a8531b04587b5592af561d"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "gettext" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on :linux
  depends_on "ncurses"

  def install
    system "./autogen.sh"
    system "./configure",
      "--disable-debug",
      "--disable-dependency-tracking",
      "--disable-silent-rules",
      "--prefix=#{prefix}"
    system "make", "install"

    # kill and uptime are also provided by coreutils
    rm [bin/"kill", bin/"uptime", man1/"kill.1", man1/"uptime.1"]
  end

  test do
    system "#{bin}/ps", "--version"
    assert_match "grep homebrew", shell_output("ps aux | grep homebrew")
  end
end
