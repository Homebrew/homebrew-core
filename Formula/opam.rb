class Opam < Formula
  desc "OCaml package manager"
  homepage "https://opam.ocaml.org"
  url "https://github.com/ocaml/opam/releases/download/2.1.0/opam-full-2.1.0.tar.gz"
  sha256 "6102131a9b65536b713efba7f5498acb3802ae15fec3171cc2c98427cfc3926f"
  license "LGPL-2.1"
  head "https://github.com/ocaml/opam.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "83fedf7b107a1cc3ea02a3782e3d830feeec7b8482a8e015707af65c0bb94ac9"
    sha256 cellar: :any_skip_relocation, big_sur:       "d34e0dcbfa4302960a8f813d4e06c113e24beff31d2fbf8e55e470c5b51ecc0b"
    sha256 cellar: :any_skip_relocation, catalina:      "882bf7f9d3f94fbbc2d5f08019456f533e0a71fd58c0a02650aa5781faefca9a"
    sha256 cellar: :any_skip_relocation, mojave:        "e091ed13ebfa241890e0489cdc2645d66c9c189f618466cf8f7576751b381726"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c566904805cf5269c17bd1691561bc2202de19df1f0ea92d4753d1788c150b8d"
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
