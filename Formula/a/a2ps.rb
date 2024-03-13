class A2ps < Formula
  desc "Any-to-PostScript filter"
  homepage "https://www.gnu.org/software/a2ps/"
  url "https://ftp.gnu.org/gnu/a2ps/a2ps-4.15.6.tar.gz"
  mirror "https://ftpmirror.gnu.org/a2ps/a2ps-4.15.6.tar.gz"
  sha256 "87ff9d801cb11969181d5b8cf8b65e65e5b24bb0c76a1b825e8098f2906fbdf4"
  license "GPL-3.0-or-later"

  bottle do
    sha256 arm64_sonoma:   "f6fec638555f04cdcb741cb9d930f95842f603e8d37c6ca5312b25c7a9e585cd"
    sha256 arm64_ventura:  "10381e1a32d8d2654c3d28fec0856d5e578178dd81341a0187923932dee8c275"
    sha256 arm64_monterey: "324fda41302930807efa0187fc74e88adaa391174a544182994c88d2f9c2c77b"
    sha256 arm64_big_sur:  "5d5e4d72ae5eab8dc359210fd20aab84afab4b1f327d0f814d3390eab2a58350"
    sha256 sonoma:         "8e4e2f2bf62b1a2382a148fe3bd1d05360ee512389b60203accc0b54dfe24201"
    sha256 ventura:        "e47f1e2e153449972ad6479f6fe7fc9522b913c975a6fb8f91d0ad6d87dfbdb7"
    sha256 monterey:       "eeb5fabb49782584d65bfe703933e4fe803cdba76b5f08e802d6ff1a4218f3da"
    sha256 big_sur:        "c2facab6afdbc5630e86dcda22286338f55958b268a5cc50e0f1c2906ed25036"
    sha256 x86_64_linux:   "40097b5e7b78f67035b8c535476f110de9072f7769670055a8ae7c0a80a78c63"
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
