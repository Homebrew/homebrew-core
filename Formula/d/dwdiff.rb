class Dwdiff < Formula
  desc "Diff that operates at the word level"
  homepage "https://os.ghalkes.nl/dwdiff.html"
  url "https://os.ghalkes.nl/dist/dwdiff-2.1.4.tar.bz2"
  sha256 "df16fec44dcb467d65a4246a43628f93741996c1773e930b90c6dde22dd58e0a"
  license "GPL-3.0-only"
  revision 11

  livecheck do
    url "https://os.ghalkes.nl/dist/"
    regex(/href=.*?dwdiff[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 arm64_tahoe:   "72db22b7bee1b3fbb618afb253f77a38a89d8f48dce43a05e4e43f00c33f49a1"
    sha256 arm64_sequoia: "a0c989ceab85b65e504e45d4ce9168d2536a523a0aeb32c5ce252227e9b9fa73"
    sha256 arm64_sonoma:  "562e9ff208d115ed67a234cefba424155674d4f8266f9eaf6c600fab69867a36"
    sha256 sonoma:        "430674eaa122cd86c378f0e894868125b0608cac9c2b7e384e09f2334560c36f"
    sha256 arm64_linux:   "9c01d60e8341d578e959b78c1c65d40a21770e70bbadd696b0ea9253446ea584"
    sha256 x86_64_linux:  "c8bdedde5a536590f5ad26a0912ea0ae15f3f0c0bd605c5356193a3e5ef4eace"
  end

  depends_on "gettext" => :build
  depends_on "pkgconf" => :build
  depends_on "icu4c@78"

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
