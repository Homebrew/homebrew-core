class Procps < Formula
  desc "Utilities for browsing procfs"
  homepage "https://gitlab.com/procps-ng/procps"
  url "https://gitlab.com/procps-ng/procps/-/archive/v4.0.4/procps-v4.0.4.tar.gz"
  sha256 "3214fab0f817d169f2c117842ba635bafb1cd6090273e311a8b5c6fc393ddb9d"
  license "GPL-2.0-or-later"
  head "https://gitlab.com/procps-ng/procps.git", branch: "master"

  bottle do
    rebuild 1
    sha256 x86_64_linux: "79434886665c5ef94464c83bf595cba0c449be107fcc70f05ec249d96814a1a7"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "gettext" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build
  depends_on :linux
  depends_on "ncurses"

  def install
    system "./autogen.sh"
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make", "install"

    # kill and uptime are also provided by coreutils
    rm [bin/"kill", bin/"uptime", man1/"kill.1", man1/"uptime.1"]
  end

  test do
    system bin/"ps", "--version"
    assert_match "grep homebrew", shell_output("#{bin}/ps aux | grep homebrew")
  end
end
