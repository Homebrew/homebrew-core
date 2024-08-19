class Dwdiff < Formula
  desc "Diff that operates at the word level"
  homepage "https://os.ghalkes.nl/dwdiff.html"
  url "https://os.ghalkes.nl/dist/dwdiff-2.1.4.tar.bz2"
  sha256 "df16fec44dcb467d65a4246a43628f93741996c1773e930b90c6dde22dd58e0a"
  license "GPL-3.0-only"
  revision 7

  livecheck do
    url "https://os.ghalkes.nl/dist/"
    regex(/href=.*?dwdiff[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "4ecea415e9ce886fbc53a585d4b55234dfbfce34ff47a2cbae47f4a10665d8c7"
    sha256 arm64_ventura:  "9101edfc5fa160b947b6559afb793a8fff4c104fea7986dbb8f87df87e14732b"
    sha256 arm64_monterey: "a174992f4aa3ca4e50c472fddc8104e1cef39795b4cca874827c490adbbd4f37"
    sha256 sonoma:         "c946589544e7b59a942693c70248be5bbb6e7e33233d8464d560b46e34aa5864"
    sha256 ventura:        "78d059b173f9943ef16596254cf228ba8183b3935bb7c3071ead89c4672fa24a"
    sha256 monterey:       "5cfa1933f2f8408600997499ae8afca84d78e1d86ffe76ea083cf6e991eebfc0"
    sha256 x86_64_linux:   "ed0a917b98a26ca0217e9e22fafa289fbc6f5092db481c10115811475d29007e"
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
