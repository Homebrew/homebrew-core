class A2ps < Formula
  desc "Any-to-PostScript filter"
  homepage "https://www.gnu.org/software/a2ps/"
  url "https://ftpmirror.gnu.org/gnu/a2ps/a2ps-4.15.7.tar.gz"
  mirror "https://ftp.gnu.org/gnu/a2ps/a2ps-4.15.7.tar.gz"
  sha256 "715f38670afd950b4ca71c01f468feefad265ca52d3f112934c63c0a8bfbb8af"
  license "GPL-3.0-or-later"

  bottle do
    sha256 arm64_tahoe:   "a0e1ed8df721dc8c255fb987d04120fc02f76fae2396b111c744008b9f71950c"
    sha256 arm64_sequoia: "09f88b61e36045188ddb1b1ba8e402b9f3debee1770cc4ca91355eeccb5f4a38"
    sha256 arm64_sonoma:  "fa5fee22382064275c78eb9c2c34149f1079d8dd55cff9109db2b9515aff5976"
    sha256 arm64_ventura: "1c84d09586d6a1dcd21cc0a5bc73879dbf075ea88f8e5d490e6bcef9add4d91d"
    sha256 sonoma:        "8d6400425422f554d9e668c3625f706989cf0ae89f36fdb57283c826febb4643"
    sha256 ventura:       "4fad7a2f054888fb432c24d9c78f86b17ebe40fc85ca6154f045195ccc2943fa"
    sha256 arm64_linux:   "df084253ef723569fb05845b1660a50a4f37f5cdc7018e8439a7b77277093081"
    sha256 x86_64_linux:  "7333d9a579dcf60c26f56c8505d8181e6d53494a659777586f067f38eb529119"
  end

  depends_on "pkgconf" => :build
  depends_on "bdw-gc"
  depends_on "libpaper"
  uses_from_macos "gperf"

  def install
    system "./configure", "--sysconfdir=#{etc}",
                          "--with-lispdir=#{elisp}",
                          "--with-packager=#{tap.user}",
                          "--with-packager-version=#{pkg_version}",
                          "--with-packager-bug-reports=#{tap.issues_url}",
                          *std_configure_args
    system "make", "install"
    inreplace etc/"a2ps.cfg", prefix, opt_prefix
  end

  test do
    (testpath/"test.txt").write("Hello World!\n")
    system bin/"a2ps", "test.txt", "-o", "test.ps"
    assert File.read("test.ps").start_with?("")
  end
end
