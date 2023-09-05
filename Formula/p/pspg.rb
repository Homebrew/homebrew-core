class Pspg < Formula
  desc "Unix pager optimized for psql"
  homepage "https://github.com/okbob/pspg"
  url "https://github.com/okbob/pspg/archive/5.8.0.tar.gz"
  sha256 "e1043e61aa18916f0c02627a32059e0f0d68f5050a38fc36ea578d517ebb12ce"
  license "BSD-2-Clause"
  head "https://github.com/okbob/pspg.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d49ab684632b45694edf0ef9dd79017b5e1209ac284a3a870d424e4cb06037d5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c594dff098e9527ceb29cf5b3b0a1a6cfc1e9ba377e5b09cd8677228274b98cc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d6e79567c50c3c159eb200c934e40a39676885e6f3c78108cf8712243564283b"
    sha256 cellar: :any_skip_relocation, ventura:        "cf4de322db99f9feef4efbf1d149d443c2fd3740784b88d1fad8433a85775c8f"
    sha256 cellar: :any_skip_relocation, monterey:       "7cf63a2b4f22948910a63742e140a636aaa13e4bf81280157b960665bae8a31c"
    sha256 cellar: :any_skip_relocation, big_sur:        "07040f3d7a5aabdcdb9228e555acdcef0916a7a8037db0fee09cf77602d8d5f6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "38bfc1ff81c68c1a049f23ef7deb8135bc3505fc6c24121e4b0075c2e58bc19c"
  end

  depends_on "libpq"
  depends_on "ncurses"
  depends_on "readline"

  def install
    system "./configure", "--disable-debug",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  def caveats
    <<~EOS
      Add the following line to your psql profile (e.g. ~/.psqlrc)
        \\setenv PAGER pspg
        \\pset border 2
        \\pset linestyle unicode
    EOS
  end

  test do
    assert_match "pspg-#{version}", shell_output("#{bin}/pspg --version")
  end
end
