class Opam < Formula
  desc "The OCaml package manager"
  homepage "https://opam.ocaml.org"
  url "https://github.com/ocaml/opam/releases/download/2.0.5/opam-full-2.0.5.tar.gz"
  sha256 "776c7e64d6e24c2ef1efd1e6a71d36e007645efae94eaf860c05c1929effc76f"
  head "https://github.com/ocaml/opam.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "2cc668fd6a919b7bfa3b0e296d0593c94a309154c2533172a8fe745d4f93b168" => :mojave
    sha256 "36febb1c4215e029892bda1fee4ea0414f6694328d286b19faf4283e32905015" => :high_sierra
    sha256 "85f550a964e5dbd248bf3e7d74e5385a763bd9e3f8545c76b90c5d4c1f03ef78" => :sierra
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
