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

  bottle do
    rebuild 1
    sha256 arm64_golden_gate: "a0d24f9d39d3fcc02d92974d7ce0a3311e8e8065faedfc50cdd06b4966f6b8f1"
    sha256 arm64_tahoe:       "ed410b5ab3fb27bc8dc7751270ad50d5128fb84471400c3c61e7226f10f1e69e"
    sha256 arm64_sequoia:     "e757347e5a6d1b1ce170d46415a23c96b919a16b054c2b0d7247314f249187b2"
    sha256 arm64_linux:       "c75c475a47e16bb292ba1de66eb13717a7f457404a84ddaf4eb7f2f07f98a30e"
    sha256 x86_64_linux:      "1e22e1d0698ff7f973ef12dfddc135e71ad1d9c6214b2c1af593ad8f2c690932"
  end

  depends_on "gettext" => :build
  depends_on "pkgconf" => :build
  depends_on "icu4c@79"

  on_macos do
    depends_on "gettext"
  end

  deny_network_access!

  def install
    if OS.mac?
      ENV.append "LDFLAGS", "-L#{formula_opt_lib("gettext")}"
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
