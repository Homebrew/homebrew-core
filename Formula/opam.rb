class Opam < Formula
  desc "The OCaml package manager"
  homepage "https://opam.ocaml.org"
  url "https://github.com/ocaml/opam/releases/download/2.0.2/opam-full-2.0.2.tar.gz"
  sha256 "eeb99fdda4b10ad3467a700fa4d1dfedb30714837d18d2faf1ef9c87d94cf0bc"
  head "https://github.com/ocaml/opam.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "40f80c1a90dc1bbe63cabf10979ba12353ad523a79d0162948eff886c5427fac" => :mojave
    sha256 "f76f5362a72ff5808931b7161074fb4de9335644c0442cbb941c70a2c2deeb03" => :high_sierra
    sha256 "904ffb1cc140dacf82d724028b341320cd9eb7b9e28d20846e5f5ecdd9deec45" => :sierra
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
