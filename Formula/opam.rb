class Opam < Formula
  desc "The OCaml package manager"
  homepage "https://opam.ocaml.org"
  url "https://github.com/ocaml/opam/releases/download/2.0.0/opam-full-2.0.0.tar.gz"
  sha256 "9dad4fcb4f53878c9daa6285d8456ccc671e21bfa71544d1f926fb8a63bfed25"
  head "https://github.com/ocaml/opam.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "6fc6f874caa189da262165ed96a5c736fa2b1a0cae2d2b001a385d97ee64d5a7" => :mojave
    sha256 "bf493fae73098388300f324fe116fc4f16bd8a0e52a9e40b2d74e50cf930d613" => :high_sierra
    sha256 "dfb95d7d716cea33067b600c7322cddbd1fb9a2e2578c75a38c83b0cc6b36900" => :sierra
    sha256 "ef2fce566058d21f080ae5229c9f84a2d692845530acb5ed272c41dfd68c5138" => :el_capitan
  end

  depends_on "ocaml" => [:build, :test]

  def install
    ENV.deparallelize

    system "./configure", "--prefix=#{prefix}", "--mandir=#{man}"
    system "make", "lib-ext"
    system "make"
    system "make", "man"
    system "make", "install"

    bash_completion.install "src/state/shellscripts/complete.sh"
    zsh_completion.install "src/state/shellscripts/complete.zsh" => "_opam"
  end

  def caveats; <<~EOS
    OPAM uses ~/.opam by default for its package database, so you need to
    initialize it first by running:

    $  opam init
  EOS
  end

  test do
    system bin/"opam", "init", "--disable-sandboxing"
    system bin/"opam", "list"
  end
end
