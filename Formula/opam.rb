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

    Run the following to initialize your environment variables:

    $  eval `opam env`

    To export the needed variables every time, add them to your dotfiles.
      * On Bash, add them to `~/.bash_profile`.
      * On Zsh, add them to `~/.zprofile` or `~/.zshrc` instead.

    Starting in 2.0.0 is also possible to set up a shell hook, so this is not
    required anymore.

    Documentation and tutorials are available at https://opam.ocaml.org, or
    via "man opam" and "opam --help".
  EOS
  end

  test do
    system bin/"opam", "--help"
  end
end
