class Opam < Formula
  desc "The OCaml package manager"
  homepage "https://opam.ocaml.org"
  url "https://github.com/ocaml/opam/releases/download/2.0.3/opam-full-2.0.3.tar.gz"
  sha256 "0589da4da184584a5445d59385009536534f60bc0e27772245b2f49e5fa8f0e2"
  head "https://github.com/ocaml/opam.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "8002e8b9d0bde7cd9c622899051968e8f33758fd912eb5d9c722402bc2d50dc0" => :mojave
    sha256 "bd88e0120905e9a71c6f2928b9b8c7645494a5021790d2d80895036afb87c548" => :high_sierra
    sha256 "8d4dfbdb8e605c8663d29b57cd6b85272ed9251c2c3feba67dfd7f767755093a" => :sierra
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
