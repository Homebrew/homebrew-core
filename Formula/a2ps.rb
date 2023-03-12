class A2ps < Formula
  desc "Any-to-PostScript filter"
  homepage "https://www.gnu.org/software/a2ps/"
  url "https://ftp.gnu.org/gnu/a2ps/a2ps-4.15.1.tar.gz"
  mirror "https://ftpmirror.gnu.org/a2ps/a2ps-4.15.1.tar.gz"
  sha256 "9797708ba02805afc3b5b91e06cb8eac97b85843a90e66cfde6a7c63ca042b2a"
  license "GPL-3.0-or-later"

  bottle do
    sha256 arm64_ventura:  "1f4cbb28e462d23e2cd0226f4ff45123cf755ff101ed1753024b6407777e0d78"
    sha256 arm64_monterey: "f1d04a06909ab271920c55cd0868cff96df60a904402cb9bae5d5c747c792781"
    sha256 arm64_big_sur:  "b2f9efa887da069bd2e1c0018418c09d824a21474c26c43a1a58eeedc8a0ea8f"
    sha256 ventura:        "32cebfb59cfabbf53b81c03fca0b216eee021186d52841f2dec78a750c423417"
    sha256 monterey:       "7d6e308a49c1af8efc0d7cf7a0f5573ed8e65360a2a993ec2d24e54235e56b9a"
    sha256 big_sur:        "f9d156a6eaa2735b934f51294f8409138ba847a8768b92b7945e16d778e439ca"
    sha256 x86_64_linux:   "d9ae57b234412323e93c6b335547187eeb3b40ca5b3d058c05d9d1a4cf943e67"
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
  end

  test do
    (testpath/"test.txt").write("Hello World!\n")
    system bin/"a2ps", "test.txt", "-o", "test.ps"
    assert File.read("test.ps").start_with?("")
  end
end
