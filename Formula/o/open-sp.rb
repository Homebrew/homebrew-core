class OpenSp < Formula
  desc "SGML parser"
  homepage "https://openjade.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/openjade/opensp/1.5.2/OpenSP-1.5.2.tar.gz"
  sha256 "57f4898498a368918b0d49c826aa434bb5b703d2c3b169beb348016ab25617ce"
  license "X11"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 5
    sha256 cellar: :any,                 arm64_tahoe:    "8686abb8d8b1f3054a19a2d57d9c2bc72820d9a5e7b61dcaea2188f103a50026"
    sha256 cellar: :any,                 arm64_sequoia:  "06f749f6c70ec8df9f8a171e3528d6d322b3d71cb59002fb4e02804f8b70bcdd"
    sha256 cellar: :any,                 arm64_sonoma:   "9e3db2e95f01de344894aad8d34353455085473885a961e3fbef3355cdaaf88f"
    sha256 cellar: :any,                 arm64_ventura:  "d6dc97e6caecf3c6090835b984cf03e7981f755e2a4e9bd884b874724fd62a34"
    sha256 cellar: :any,                 arm64_monterey: "803db865811e2af00d1ea784c7bf0ed5d8b837f9bd5afff47bca13a5b97e8955"
    sha256 cellar: :any,                 arm64_big_sur:  "032676f1cd5c4bc0c1368cdf08bfe9a8b6df8f2c26ee4367c4a1285ab4fadc3a"
    sha256 cellar: :any,                 sonoma:         "c08e40944818db7868c5d8338c3abe08e16dcac1b9f4b34edb054048a9dd4aa3"
    sha256 cellar: :any,                 ventura:        "4075ad44cb25e963f435a1f48a9cc910c00d2de4ab2623fe803422910b0ba325"
    sha256 cellar: :any,                 monterey:       "5c869b71025c07d7b86088189985d9a22c0f0c9fb719b775fb2388f5a0cbb16f"
    sha256 cellar: :any,                 big_sur:        "50109cdb514313693454259ba30f90f550618d48a1cc71df55ed04343d0cf641"
    sha256 cellar: :any,                 catalina:       "1b2c18d6cdcd99d387770eaa14a773bb3edec5b22984ac75f3b07a181916f18f"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "597213ee29de34da7d34d395ea5f6c8fb4681c5512934e3837f17e0d8628f012"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "11f6bb56e019bea8f5fb9e2d38e62102230278ddc8fce115755a1cf6a6cbda54"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "docbook" => :build
  depends_on "ghostscript" => :build
  depends_on "libtool" => :build
  depends_on "xmlto" => :build
  depends_on "gettext"

  # Apply Gentoo patch to fix build error: ISO C++11 does not allow access declarations
  patch do
    url "https://gitweb.gentoo.org/repo/gentoo.git/plain/app-text/opensp/files/opensp-1.5.2-c11-using.patch?id=688d9675782dfc162d4e6cff04c668f7516118d0"
    sha256 "3ebd2526e0f41a12b9107a09ece834043678d499252c28941eeb2a5676b1ce5e"
  end

  def install
    ENV["XML_CATALOG_FILES"] = "#{etc}/xml/catalog"

    # The included ./configure file is too old to work with Xcode 12
    system "autoreconf", "--force", "--install", "--verbose"
    system "./configure", "--mandir=#{man}",
                          "--enable-http",
                          "--enable-default-catalog=#{etc}/sgml/catalog",
                          *std_configure_args
    system "make", "pkgdatadir=#{share}/sgml/opensp", "install"
  end

  test do
    (testpath/"eg.sgml").write <<~EOS
      <!DOCTYPE TESTDOC [

      <!ELEMENT TESTDOC - - (TESTELEMENT)+>
      <!ELEMENT TESTELEMENT - - (#PCDATA)>

      ]>
      <TESTDOC>
        <TESTELEMENT>Hello</TESTELEMENT>
      </TESTDOC>
    EOS

    system bin/"onsgmls", "--warning=type-valid", "eg.sgml"
  end
end
