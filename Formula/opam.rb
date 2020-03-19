class Opam < Formula
  desc "The OCaml package manager"
  homepage "https://opam.ocaml.org"
  url "https://github.com/ocaml/opam/releases/download/2.0.6/opam-full-2.0.6.tar.gz"
  sha256 "7c4bff5e5f3628ad00c53ee1b044ced8128ffdcfbb7582f8773fb433e12e07f4"
  head "https://github.com/ocaml/opam.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "54e18e947ab5a8d2af76cefeb3707be24ad54d4d475851b372aac766d5350d14" => :catalina
    sha256 "6c2a6796eead34e1116bd37e0ade8a1ad34ceeef98e396cfc36f26d591a21de6" => :mojave
    sha256 "941366068ed9c5743d09635128defeecfcf52b3663a1fbff04d2003ded76ae89" => :high_sierra
  end

  depends_on "ocaml" => [:build, :test]

  uses_from_macos "unzip"

  def install
    ENV.deparallelize

    system "./configure", "--prefix=#{prefix}", "--mandir=#{man}"
    system "make", "lib-ext"
    system "make"
    system "make", "install"

    bash_completion.install "src/state/shellscripts/complete.sh"
    zsh_completion.install "src/state/shellscripts/complete.zsh" => "_opam"
  end

  def caveats
    <<~EOS
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
