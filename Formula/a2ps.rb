class A2ps < Formula
  desc "Any-to-PostScript filter"
  homepage "https://www.gnu.org/software/a2ps/"
  url "https://ftp.gnu.org/gnu/a2ps/a2ps-4.15.4.tar.gz"
  mirror "https://ftpmirror.gnu.org/a2ps/a2ps-4.15.4.tar.gz"
  sha256 "4a063f84ba89d86be14a6704ca35fd130083b572f1376b439a1b79b67b206dd7"
  license "GPL-3.0-or-later"

  bottle do
    rebuild 1
    sha256 arm64_ventura:  "c28ce183c0df4d35f1140e165de4c5593a18068af361442fede10817f10b81a8"
    sha256 arm64_monterey: "597f5136d784db545c8bbd5d891489b06ab393ded136d33763e2446ba59e3fe9"
    sha256 arm64_big_sur:  "5fb5f93131b431a2e3988f5d2eff563f7c182945510208864fd390b0eb0f0259"
    sha256 ventura:        "d3d19336e88234fa24209b0b04ed5cb7cd9587b38e9dd2a0710df3de76054b71"
    sha256 monterey:       "82d1439cf852341777756d040a7b92eef28e4573552ac0f132d646d604945d40"
    sha256 big_sur:        "776ad3531fb2fc22ca8c6177703adf4deaaddc3d4fa445ecbde9266a93e406c0"
    sha256 x86_64_linux:   "5c67b006ea1afd535cdb5f8c8edba4ed609fc7de3583f1108d4b3a83ff803f1e"
  end

  depends_on "pkg-config" => :build
  depends_on "bdw-gc"
  depends_on "libpaper"
  uses_from_macos "gperf"

  def install
    system "./configure", *std_configure_args,
                          "--sysconfdir=#{etc}",
                          "--with-lispdir=#{elisp}",
                          "--with-packager=#{tap.user}",
                          "--with-packager-version=#{pkg_version}",
                          "--with-packager-bug-reports=#{tap.issues_url}"
    system "make", "install"
    inreplace etc/"a2ps.cfg", prefix, opt_prefix
  end

  test do
    (testpath/"test.txt").write("Hello World!\n")
    system bin/"a2ps", "test.txt", "-o", "test.ps"
    assert File.read("test.ps").start_with?("")
  end
end
