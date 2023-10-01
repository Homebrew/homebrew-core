class Groff < Formula
  desc "GNU troff text-formatting system"
  homepage "https://www.gnu.org/software/groff/"
  url "https://ftp.gnu.org/gnu/groff/groff-1.23.0.tar.gz"
  mirror "https://ftpmirror.gnu.org/groff/groff-1.23.0.tar.gz"
  sha256 "6b9757f592b7518b4902eb6af7e54570bdccba37a871fddb2d30ae3863511c13"
  license "GPL-3.0-or-later"

  bottle do
    sha256 arm64_sonoma:   "ce07a3e98fa6cfff23826e993d638c12f833b9fb5fc9c2a3593364b0be162031"
    sha256 arm64_ventura:  "c6d152d002365b25c67782fed7ca0141ee3dafaaa0e726bf3df427d469fb73ce"
    sha256 arm64_monterey: "4926259bc0c75eb28f9d288c618ae84dc1a1a14952f3f414054e01ef5be345d0"
    sha256 arm64_big_sur:  "e4dfe40ef95e535d7f9c98e3743ce42112ae74c8aa3cfc4f30089c53aa123ba4"
    sha256 sonoma:         "e5763fdbb5fb595f8b4588f19b9a5785739568075884563f79dc35fb3c1d2580"
    sha256 ventura:        "841d00a033f005f7e9eefed0d1190402879de5568a6624e494a52c581353bf5a"
    sha256 monterey:       "a0bfb5d123ae6766a69b8d245bcc8d0323e8f6bce3f7c55c89403939ba176d46"
    sha256 big_sur:        "8e8f79c4969912bf20f183dc3450001dc952b94967dca5cea18a7379d9d54f55"
    sha256 x86_64_linux:   "621ff79fc4f7ff2d66f78b96e1b3229aed81c49cb13831a46918841696b35428"
  end

  depends_on "pkg-config" => :build
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
    system "./configure", "--prefix=#{prefix}", "--without-x", "--with-uchardet"
    system "make" # Separate steps required
    system "make", "install"
  end

  test do
    assert_match "homebrew\n",
      pipe_output("#{bin}/groff -a", "homebrew\n")
  end
end
