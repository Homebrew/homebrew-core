class Libvoikko < Formula
  desc "Linguistic software and Finnish dictionary"
  homepage "https://voikko.puimula.org/"
  url "https://www.puimula.org/voikko-sources/libvoikko/libvoikko-4.3.1.tar.gz"
  sha256 "368240d4cfa472c2e2c43dc04b63e6464a3e6d282045848f420d0f7a6eb09a13"
  license "GPL-2.0-only"

  livecheck do
    url "https://www.puimula.org/voikko-sources/libvoikko/"
    regex(/href=.*?libvoikko[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_monterey: "bf4aa996837cb8eb1c000949a487966d5deb6ce3d6ccd8fcf877442af65a0053"
    sha256 cellar: :any,                 arm64_big_sur:  "4268b4f20b4188f01bb26f407a46072f78533deb885e5c524e03ac0f52b34cfd"
    sha256 cellar: :any,                 monterey:       "d7c7153b746f693b568d91aa33b5e31e12606628a410949978e867fce6c95830"
    sha256 cellar: :any,                 big_sur:        "523ea2f2f1d90a9ecb5e3480dd21be34aec7fdd1aab436fcd1c7e086b7d5a974"
    sha256 cellar: :any,                 catalina:       "122c2876b26e22df22bcce9557b2f1ef52c0529742a7a8a10b2f78e56164281d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4017cb4a9720f4da0d144f4ed811dcd8328b788471cecf8bea2e3d45a5d6a66f"
  end

  depends_on "foma" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.10" => :build
  depends_on "hfstospell"

  resource "voikko-fi" do
    url "https://www.puimula.org/voikko-sources/voikko-fi/voikko-fi-2.4.tar.gz"
    sha256 "320b2d4e428f6beba9d0ab0d775f8fbe150284fbbafaf3e5afaf02524cee28cc"
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--with-dictionary-path=#{HOMEBREW_PREFIX}/lib/voikko"
    system "make", "install"

    resource("voikko-fi").stage do
      ENV.append_path "PATH", bin.to_s
      system "make", "vvfst"
      system "make", "vvfst-install", "DESTDIR=#{lib}/voikko"
      lib.install_symlink "voikko"
    end
  end

  test do
    assert_match "C: onkohan", pipe_output("#{bin}/voikkospell -m", "onkohan\n")
  end
end
