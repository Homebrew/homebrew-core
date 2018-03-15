class CrosstoolNg < Formula
  desc "Tool for building toolchains"
  homepage "http://crosstool-ng.org"
  url "http://crosstool-ng.org/download/crosstool-ng/crosstool-ng-1.23.0.tar.xz"
  sha256 "68a43ea98ccf9cb345cb6eec494a497b224fee24c882e8c14c6713afbbe79196"
  revision 1

  bottle do
    cellar :any
    sha256 "54205dfad10ed81d0cb31692e852b5742a938a6a54b7e116e5820d3a0d6dded2" => :high_sierra
    sha256 "185f1d5981772306bac468ca496555140c761137e771955c1d63800dae894559" => :sierra
    sha256 "d3aebb66365f24fde4fd67a4ec13eb72c0f21e94904853e39003b7b05c53bad5" => :el_capitan
  end

  depends_on "help2man" => :build
  depends_on "autoconf" => :run
  depends_on "automake" => :run
  depends_on "libtool" => :run
  depends_on "binutils"
  depends_on "coreutils"
  depends_on "flex"
  depends_on "gawk"
  depends_on "gnu-sed"
  depends_on "grep"
  depends_on "m4"
  depends_on "xz"

  def install
    ENV["M4"] = "#{Formula["m4"].opt_bin}/m4"
    ENV["MAKE"] = "/usr/bin/make" # prevent hardcoding make path from superenv

    system "./configure", "--prefix=#{prefix}"

    # Must be done in two steps
    system "make"
    system "make", "install"
  end

  test do
    assert_match "This is crosstool-NG", shell_output("make -rf #{bin}/ct-ng version")
  end
end
