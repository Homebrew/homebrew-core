class ProofGeneral < Formula
  desc "Emacs-based generic interface for theorem provers"
  homepage "https://proofgeneral.github.io"
  url "https://github.com/ProofGeneral/PG/archive/v4.4.tar.gz"
  sha256 "1ba236d81768a87afa0287f49d4b2223097bc61d180468cbd997d46ab6132e7e"
  revision 2
  head "https://github.com/ProofGeneral/PG.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "a9c3dca4c71aae78779bcf34fc98b914cee3d000dfbe18aaa29ec6f6c9f00af6" => :high_sierra
    sha256 "3873ed2362ff17d7cc51fc5910bddb57f1fd23a294fe5747c4bc7b143c0b71d2" => :sierra
    sha256 "2ceb9862d81f46f6ba815b58a1683ce8af5a95b6db0f4c1bfde488156c56ce62" => :el_capitan
    sha256 "2ceb9862d81f46f6ba815b58a1683ce8af5a95b6db0f4c1bfde488156c56ce62" => :yosemite
  end

  depends_on "texi2html" => :build
  depends_on "emacs"

  def install
    ENV.deparallelize # Otherwise lisp compilation can result in 0-byte files

    args = %W[
      PREFIX=#{prefix}
      DEST_PREFIX=#{prefix}
      ELISPP=share/emacs/site-lisp/proof-general
      ELISP_START=#{elisp}/site-start.d
      EMACS=#{which "emacs"}
    ]

    system "make", "install", *args

    cd "doc" do
      system "make", "info", "html"
    end
    man1.install "doc/proofgeneral.1"
    info.install "doc/ProofGeneral.info", "doc/PG-adapting.info"
    doc.install "doc/ProofGeneral", "doc/PG-adapting"
  end

  def caveats; <<~EOS
    HTML documentation is available in: #{HOMEBREW_PREFIX}/share/doc/proof-general
    EOS
  end

  test do
    system bin/"proofgeneral", "--help"
  end
end
