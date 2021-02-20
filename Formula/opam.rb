class Opam < Formula
  desc "OCaml package manager"
  homepage "https://opam.ocaml.org"
  url "https://github.com/ocaml/opam/releases/download/2.0.8/opam-full-2.0.8.tar.gz"
  sha256 "7b9d29233d9633ef50ba766df2e39112b15cd05c1c6fedf80bcb548debcdd9bd"
  license "LGPL-2.1"
  head "https://github.com/ocaml/opam.git"

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:  "d34e0dcbfa4302960a8f813d4e06c113e24beff31d2fbf8e55e470c5b51ecc0b"
    sha256 cellar: :any_skip_relocation, catalina: "882bf7f9d3f94fbbc2d5f08019456f533e0a71fd58c0a02650aa5781faefca9a"
    sha256 cellar: :any_skip_relocation, mojave:   "e091ed13ebfa241890e0489cdc2645d66c9c189f618466cf8f7576751b381726"
  end

  depends_on "ocaml" => [:build, :test]
  depends_on "gpatch"

  uses_from_macos "unzip"

  def install
    ENV.deparallelize

    system "./configure", "--prefix=#{prefix}", "--mandir=#{man}"
    system "make", "lib-ext"
    system "make"
    system "make", "install"

    bash_completion.install "src/state/shellscripts/complete.sh" => "opam"
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
