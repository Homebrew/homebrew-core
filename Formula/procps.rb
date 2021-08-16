class Procps < Formula
  desc "Utilities for browsing procfs"
  homepage "https://gitlab.com/procps-ng/procps"
  url "https://gitlab.com/procps-ng/procps/-/archive/v3.3.17/procps-v3.3.17.tar.gz"
  sha256 "efa6f6b4625a795f5c8a3d5bd630a121d270bc8573c5a0b6a6068e73611d6cd5"
  license "GPL-2.0-or-later"
  head "https://gitlab.com/procps-ng/procps.git"

  bottle do
    sha256 x86_64_linux: "873b1756b34961702aa8eb6a69271b0d9e1b33ac76d4d0b37a238d4d825fc048"
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
