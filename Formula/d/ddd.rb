class Ddd < Formula
  desc "Graphical front-end for command-line debuggers"
  homepage "https://www.gnu.org/s/ddd/"
  url "https://ftp.gnu.org/gnu/ddd/ddd-3.4.0.tar.gz"
  mirror "https://ftpmirror.gnu.org/ddd/ddd-3.4.0.tar.gz"
  sha256 "5d4cbc8a0bb0458543866d679308c53a3ef066e402fe5a1918e19698a3d3580f"
  license all_of: ["GPL-3.0-only", "GFDL-1.1-or-later"]

  bottle do
    sha256 sonoma:       "aebf4974ee7aa21c65355662a1cacac7ffa0f376dc2b8b42b7bb9a9b9855f934"
    sha256 ventura:      "e83d30cbbf7149a044e20f8a874f590d942dc5a377b4ea8cac7f92b9b2c11473"
    sha256 monterey:     "4473c8af5c52c43e08ed9c4f0982ae086d6a4224830575b8b0dde893a16b47bf"
    sha256 big_sur:      "6f2d07fb46a5580cef95fe26a9babee60eb4378930e68f389f07e5897fd1a473"
    sha256 x86_64_linux: "deba8dc6677abab583705dbdbbf259c7c77bf5bd9491a3ae006a372f3696dda2"
  end

  depends_on "gdb" => :test
  depends_on arch: :x86_64 # gdb is not supported on macOS ARM
  depends_on "libice"
  depends_on "libsm"
  depends_on "libx11"
  depends_on "libxau"
  depends_on "libxaw"
  depends_on "libxext"
  depends_on "libxp"
  depends_on "libxpm"
  depends_on "libxt"
  depends_on "openmotif"

  def install
    # ioctl is not found without this flag
    # Upstream issue ref: https://savannah.gnu.org/bugs/index.php?64188
    ENV.append_to_cflags "-DHAVE_SYS_IOCTL_H" if OS.mac?

    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--enable-builtin-app-defaults",
                          "--enable-builtin-manual",
                          "--prefix=#{prefix}"

    # From MacPorts: make will build the executable "ddd" and the X resource
    # file "Ddd" in the same directory, as HFS+ is case-insensitive by default
    # this will loosely FAIL
    system "make", "EXEEXT=exe"

    ENV.deparallelize
    system "make", "install", "EXEEXT=exe"
    mv bin/"dddexe", bin/"ddd"
  end

  test do
    output = shell_output("#{bin}/ddd --version")
    output.force_encoding("ASCII-8BIT") if output.respond_to?(:force_encoding)
    assert_match version.to_s, output
    assert_match testpath.to_s, pipe_output("#{bin}/ddd --gdb --nw true 2>&1", "pwd\nquit")
  end
end
