class ProofGeneral < Formula
  desc "Emacs-based generic interface for theorem provers"
  homepage "https://proofgeneral.github.io"
  url "https://github.com/ProofGeneral/PG/archive/v4.5.tar.gz"
  sha256 "b408ab943cfbfe4fcb0d3322f079f41e2a2d29b50cf0cc704fbb4d5e6c26e3a2"
  license "GPL-3.0-or-later"
  head "https://github.com/ProofGeneral/PG.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5f8c9ac9e7c89e5d24b6045a20a08a80b20bdd6f3a93ef643e5ce3630c35d877"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5f8c9ac9e7c89e5d24b6045a20a08a80b20bdd6f3a93ef643e5ce3630c35d877"
    sha256 cellar: :any_skip_relocation, monterey:       "0d3054b85b1e07a7b0eb5d07cfe387d43428c5aa4602505f08e41a8148d8f66b"
    sha256 cellar: :any_skip_relocation, big_sur:        "0d3054b85b1e07a7b0eb5d07cfe387d43428c5aa4602505f08e41a8148d8f66b"
    sha256 cellar: :any_skip_relocation, catalina:       "0d3054b85b1e07a7b0eb5d07cfe387d43428c5aa4602505f08e41a8148d8f66b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5f8c9ac9e7c89e5d24b6045a20a08a80b20bdd6f3a93ef643e5ce3630c35d877"
  end

  depends_on "texi2html" => :build
  depends_on "texinfo" => :build
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

  def caveats
    <<~EOS
      HTML documentation is available in: #{HOMEBREW_PREFIX}/share/doc/proof-general
    EOS
  end

  test do
    system bin/"coqtags", "--help"
  end
end
