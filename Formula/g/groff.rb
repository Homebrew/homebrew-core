class Groff < Formula
  desc "GNU troff text-formatting system"
  homepage "https://www.gnu.org/software/groff/"
  url "https://ftpmirror.gnu.org/gnu/groff/groff-1.23.0.tar.gz"
  mirror "https://ftp.gnu.org/gnu/groff/groff-1.23.0.tar.gz"
  sha256 "6b9757f592b7518b4902eb6af7e54570bdccba37a871fddb2d30ae3863511c13"
  license "GPL-3.0-or-later"
  revision 1

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 arm64_tahoe:    "7684d4604e213bf74894799b38f98153e743c504c493d7cedff5c25109d46854"
    sha256 arm64_sequoia:  "46fa52805546514d174798f2a8723a84827c13c2c7c106e246c9ff77b43eb4cf"
    sha256 arm64_sonoma:   "14b00074485891c952dbb2a72627569a39f9f5ad7f0d0dd96c82474dfbc93811"
    sha256 arm64_ventura:  "5a8b3ab0c971b1667066be5f6e16581f533ceb035a4990a906ad04bcc5386738"
    sha256 arm64_monterey: "ecbb5f2eaea937aeaf4182cb9b92a6a8ad20d7bbf7379769879ad70421fb6483"
    sha256 sonoma:         "9574ff7b3847c05c48197519ad4ce3a9084311f166b579801d58b892e336641a"
    sha256 ventura:        "6843e8adc54c9f26440aa7772111e5865f206b911199811a2874a48a5bcc197b"
    sha256 monterey:       "ad660d68652c600a83c0e2ab13c2cf083a3af3e85a0c7dfd0251b527f7094a93"
    sha256 arm64_linux:    "d97896a245ea632bd21f88cbc8cb1ce9022e219dcb11a3eb5ec119436c21f547"
    sha256 x86_64_linux:   "4fed3742a3cf824d5753a3ae998097d1a36d8c2c97ae459d6a813bd766b7c2ae"
  end

  depends_on "pkgconf" => :build
  depends_on "ghostscript"
  depends_on "netpbm"
  depends_on "psutils"
  depends_on "uchardet"

  uses_from_macos "bison" => :build
  uses_from_macos "perl"

  on_system :linux, macos: :ventura_or_newer do
    depends_on "texinfo" => :build
  end

  on_linux do
    depends_on "glib"
  end

  def install
    # Local config needs to survive upgrades
    inreplace "Makefile.in" do |s|
      s.change_make_var! "localfontdir", "@sysconfdir@/groff/site-font"
      s.change_make_var! "localtmacdir", "@sysconfdir@/groff/site-tmac"
    end
    system "./configure", "--sysconfdir=#{etc}",
                          "--without-x",
                          "--with-uchardet",
                          *std_configure_args
    system "make" # Separate steps required
    system "make", "install"
  end

  test do
    assert_match "homebrew\n", pipe_output("#{bin}/groff -a", "homebrew\n")
  end
end
