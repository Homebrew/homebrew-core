class ProofGeneral < Formula
  desc "Emacs-based generic interface for theorem provers"
  homepage "https://proofgeneral.github.io"
  url "https://github.com/ProofGeneral/PG/archive/refs/tags/v4.5.tar.gz"
  sha256 "b408ab943cfbfe4fcb0d3322f079f41e2a2d29b50cf0cc704fbb4d5e6c26e3a2"
  license "GPL-3.0-or-later"
  head "https://github.com/ProofGeneral/PG.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "4efbf2e4aacd72d00f58a2f6a0f0748790e44a22af1bf97543c29ce077c133de"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "f0afc78703aed0f2cdd4ec47dc841b5bf2ecc69b52d7f4a1b3ef7c2189a127b4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b0c27f7ce047eac700c1aa07cf9a723b54f4bb0d2f62ee2375bde197a5434af9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b87a94e0c06c19d5d57aedd9a628b69a22d559cfd331f563dcb93c02b5f0a402"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b87a94e0c06c19d5d57aedd9a628b69a22d559cfd331f563dcb93c02b5f0a402"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b87a94e0c06c19d5d57aedd9a628b69a22d559cfd331f563dcb93c02b5f0a402"
    sha256 cellar: :any_skip_relocation, sonoma:         "4c7ea3668b2b0df4de8eb60962f128fdbb26fbf1c7f72511c67a707c3d0c833c"
    sha256 cellar: :any_skip_relocation, ventura:        "e0f721f16c2c5e2ffa6b7ef00595ab6bdbdeda815f00a04ca30d2df2cc474e8b"
    sha256 cellar: :any_skip_relocation, monterey:       "e0f721f16c2c5e2ffa6b7ef00595ab6bdbdeda815f00a04ca30d2df2cc474e8b"
    sha256 cellar: :any_skip_relocation, big_sur:        "e0f721f16c2c5e2ffa6b7ef00595ab6bdbdeda815f00a04ca30d2df2cc474e8b"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "68fae82f1c9768c66e94b3a413a4b8c17ab7207629e1faf8645593a8bda8cfb5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b87a94e0c06c19d5d57aedd9a628b69a22d559cfd331f563dcb93c02b5f0a402"
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
    doc.install "doc/ProofGeneral_html", "doc/PG-adapting_html"
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
