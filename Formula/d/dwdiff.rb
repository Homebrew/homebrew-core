class Dwdiff < Formula
  desc "Diff that operates at the word level"
  homepage "https://os.ghalkes.nl/dwdiff.html"
  url "https://os.ghalkes.nl/dist/dwdiff-2.1.4.tar.bz2"
  sha256 "df16fec44dcb467d65a4246a43628f93741996c1773e930b90c6dde22dd58e0a"
  license "GPL-3.0-only"
  revision 8

  livecheck do
    url "https://os.ghalkes.nl/dist/"
    regex(/href=.*?dwdiff[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia: "d90a643eaf8cc3082fd794c9bb42828d714b7210ef2665f6092b8ec594c54190"
    sha256 arm64_sonoma:  "abdb1e40a84046f9d688445ebd2653760ff47d7ba4a936e5a004127ace23d1ce"
    sha256 arm64_ventura: "4df114d93a324690c0248afd9c4c8c8b22a5fe405ec54f265b11cc517e55eff1"
    sha256 sonoma:        "f0c3cbd93edfd0a3fbc036caffaa232d05efb1e08170fc45da1e05e5a0398001"
    sha256 ventura:       "c551a06c3680a70338824429715c0676ddd73693c308c777a5420d56ad420af7"
    sha256 x86_64_linux:  "41e355648b408db8ae80461ad72ea0ff04e91c906aa0377476e039a8a2e637ea"
  end

  depends_on "gettext" => :build
  depends_on "pkg-config" => :build
  depends_on "icu4c@75"

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
