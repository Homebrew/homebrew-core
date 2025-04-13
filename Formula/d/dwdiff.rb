class Dwdiff < Formula
  desc "Diff that operates at the word level"
  homepage "https://os.ghalkes.nl/dwdiff.html"
  url "https://os.ghalkes.nl/dist/dwdiff-2.1.4.tar.bz2"
  sha256 "df16fec44dcb467d65a4246a43628f93741996c1773e930b90c6dde22dd58e0a"
  license "GPL-3.0-only"
  revision 10

  livecheck do
    url "https://os.ghalkes.nl/dist/"
    regex(/href=.*?dwdiff[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia: "2bda3e2dc11d88fe1187f0c479198d710779c408f9debd48eaa848916e64e593"
    sha256 arm64_sonoma:  "cf43f7fbb5c7c51a9e8405ac9ea2e9a980ba17359af8aa027863ee012a7442b0"
    sha256 arm64_ventura: "511603ea7b355abb986d9b45e2912b59e719e2ec7f6c415eb0bb778e64258416"
    sha256 sonoma:        "7730f283a9efac877b8453ca6bc8e5e607070a7f8709c8f88954cec6f46e9f3a"
    sha256 ventura:       "ac4571535c285d3dcbd6adf7e79db5dc50995947ec677a003565f2a9df314fb2"
    sha256 arm64_linux:   "90ca067849e43e2acfa5c08132957517e9501a05c14bca444faa07e42ffef37d"
    sha256 x86_64_linux:  "99b048bb74cafa479edca91407c074c45b6047b08a4c2f75ab67ddc3094e6215"
  end

  depends_on "gettext" => :build
  depends_on "pkgconf" => :build
  depends_on "icu4c@77"

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
