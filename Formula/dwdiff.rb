class Dwdiff < Formula
  desc "Diff that operates at the word level"
  homepage "https://os.ghalkes.nl/dwdiff.html"
  url "https://os.ghalkes.nl/dist/dwdiff-2.1.4.tar.bz2"
  sha256 "df16fec44dcb467d65a4246a43628f93741996c1773e930b90c6dde22dd58e0a"
  license "GPL-3.0-only"
  revision 2

  livecheck do
    url "https://os.ghalkes.nl/dist/"
    regex(/href=.*?dwdiff[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "d9d5288ce21cf9c002d8a0c57a0c88f1a8bb97af0c038f4a728d58c46ab84a46"
    sha256 arm64_big_sur:  "04a95671f514c40ef0998a8d3304aa98b50f302ea8f6068bc93a7804db1e77e0"
    sha256 monterey:       "6819f3f8f6b9586cda1ef6de1993196219a49179aaff34e670b036d8e21ba6fb"
    sha256 big_sur:        "c4527f38e48df252ac20b4bc6ebc7c24baf1c3f8f157c16a5218db5e17cbf22e"
    sha256 catalina:       "05fc8c8568063207dfb1d52149367cb2bbc960e41fecd09b63790e6b372ceb99"
    sha256 mojave:         "ee28eff81ca945f765afe6a62110e603d40108ac112c3db3ec6b859438fdbda3"
    sha256 x86_64_linux:   "bb0d5aa169f1d00fdabe5bf26b4769b3cbdfc288b4c1dbeaf1592d6b9d09d7a4"
  end

  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "icu4c"

  def install
    gettext = Formula["gettext"]
    icu4c = Formula["icu4c"]
    ENV.append "CFLAGS", "-I#{gettext.include} -I#{icu4c.include}"
    ENV.append "LDFLAGS", "-L#{gettext.lib} -L#{icu4c.lib}"
    ENV.append "LDFLAGS", "-lintl" if OS.mac?

    system "./configure", "--prefix=#{prefix}"
    system "make", "install"

    # Remove non-English man pages
    (man/"nl").rmtree
    (man/"nl.UTF-8").rmtree
    (share/"locale/nl").rmtree
  end

  test do
    (testpath/"a").write "I like beers"
    (testpath/"b").write "I like formulae"
    diff = shell_output("#{bin}/dwdiff a b", 1)
    assert_equal "I like [-beers-] {+formulae+}", diff
  end
end
