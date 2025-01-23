class Dwdiff < Formula
  desc "Diff that operates at the word level"
  homepage "https://os.ghalkes.nl/dwdiff.html"
  url "https://os.ghalkes.nl/dist/dwdiff-2.1.4.tar.bz2"
  sha256 "df16fec44dcb467d65a4246a43628f93741996c1773e930b90c6dde22dd58e0a"
  license "GPL-3.0-only"
  revision 9

  livecheck do
    url "https://os.ghalkes.nl/dist/"
    regex(/href=.*?dwdiff[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia: "4053f66e01f71ec7f80907c695eb59d736745ab1d1b9c2621dea89bbd615fee3"
    sha256 arm64_sonoma:  "5473444b308b87303d4445af35c90380693a873c3d7e6d6486ab508012ff04bc"
    sha256 arm64_ventura: "873efda9ea47a92db7560062e277048de7c833b781e07bd9b335f4db396fda9c"
    sha256 sonoma:        "3ca89143ef23df44be9d6498147cc3cedd21ef6ec8333477324e3e9821587801"
    sha256 ventura:       "fc6ba13a7d47dddf52c3da588445d2ff8a598a82ce1d555f624b7101f74755ab"
    sha256 x86_64_linux:  "4a1d2676609cb71de95b4062bf5f72bbcaaf69329d7d55f7f269d31a0e9feced"
  end

  depends_on "gettext" => :build
  depends_on "pkgconf" => :build
  depends_on "icu4c@76"

  on_macos do
    depends_on "gettext"
  end

  def install
    if OS.mac?
      ENV.append "LDFLAGS", "-L#{Formula["gettext"].opt_lib}"
      ENV.append "LDLIBS", "-lintl"
    end

    system "./configure", "--prefix=#{prefix}"
    system "make", "install"

    # Remove non-English man pages
    rm_r(man/"nl")
    rm_r(man/"nl.UTF-8")
    rm_r(share/"locale/nl")
  end

  test do
    (testpath/"a").write "I like beers"
    (testpath/"b").write "I like formulae"
    diff = shell_output("#{bin}/dwdiff a b", 1)
    assert_equal "I like [-beers-] {+formulae+}", diff
  end
end
