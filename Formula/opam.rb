class Opam < Formula
  desc "The OCaml package manager"
  homepage "https://opam.ocaml.org"
  url "https://github.com/ocaml/opam/releases/download/2.0.2/opam-full-2.0.2.tar.gz"
  sha256 "eeb99fdda4b10ad3467a700fa4d1dfedb30714837d18d2faf1ef9c87d94cf0bc"
  head "https://github.com/ocaml/opam.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "15f4476cddcbc0f03a5b41c6d418bf046b2d1f8e698ba0d3c4e27ad842b8a8f3" => :mojave
    sha256 "607194900ea95308fa3457c4e016a728000b3e106c7342c7303c88f68e74e461" => :high_sierra
    sha256 "28b780b4abce49bdd9c05b554d399845a418d5d706de981fb9885cefc66517f7" => :sierra
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

    $ opam init
  EOS
  end

  test do
    system bin/"opam", "init", "--disable-sandboxing"
    system bin/"opam", "list"
  end
end
