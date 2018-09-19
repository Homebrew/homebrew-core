class Opam < Formula
  desc "The OCaml package manager"
  homepage "https://opam.ocaml.org"
  url "https://github.com/ocaml/opam/releases/download/2.0.0/opam-full-2.0.0.tar.gz"
  sha256 "9dad4fcb4f53878c9daa6285d8456ccc671e21bfa71544d1f926fb8a63bfed25"
  head "https://github.com/ocaml/opam.git"

  depends_on "glpk" => :build
  depends_on "ocaml" => :recommended

  def install
    ENV.deparallelize

    build_ocaml = build.without? "ocaml"

    if build_ocaml
      system "make", "cold", "CONFIGURE_ARGS=--prefix #{prefix} --mandir #{man}"
      ENV.prepend_path "PATH", "#{buildpath}/bootstrap/ocaml/bin"
    else
      system "./configure", "--prefix=#{prefix}", "--mandir=#{man}"
      system "make", "lib-ext"
      system "make"
    end
    system "make", "man"
    system "make", "install"

    bash_completion.install "src/state/shellscripts/complete.sh"
    zsh_completion.install "src/state/shellscripts/complete.zsh" => "_opam"
  end

  def caveats; <<~EOS
    OPAM uses ~/.opam by default for its package database, so you need to
    initialize it first by running (as a normal user):

    $  opam init

  EOS
  end

  test do
    system bin/"opam", "--help"
  end
end
