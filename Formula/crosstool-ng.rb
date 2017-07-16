class CrosstoolNg < Formula
  desc "Tool for building toolchains"
  homepage "http://crosstool-ng.org"
  url "http://crosstool-ng.org/download/crosstool-ng/crosstool-ng-1.23.0.tar.xz"
  sha256 "68a43ea98ccf9cb345cb6eec494a497b224fee24c882e8c14c6713afbbe79196"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "3ada31fa193f947f2145794eb2b24f12b0d27106c707685f0e92678ac180d9e0" => :sierra
    sha256 "1563e4b907a4e290d0b3b4e9c0bbfb840f42eb90b2c1a10c7a6632560d59dd9e" => :el_capitan
    sha256 "a1a7a286d87ff625b6e5910f962e0248ddd610dcf91ddd3b8923bf4f7476a23d" => :yosemite
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

    system "./configure", "--prefix=#{prefix}"

    # Must be done in two steps
    system "make"
    system "make", "install"
  end

  test do
    assert_match "This is crosstool-NG", shell_output("make -rf #{bin}/ct-ng version")
  end
end
