class Opam < Formula
  desc "The OCaml package manager"
  homepage "https://opam.ocaml.org"
  url "https://github.com/ocaml/opam/releases/download/2.0.5/opam-full-2.0.5.tar.gz"
  sha256 "776c7e64d6e24c2ef1efd1e6a71d36e007645efae94eaf860c05c1929effc76f"
  head "https://github.com/ocaml/opam.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "2eaa945aa00834374c7170da065b5d2c15a5df25130bb9b336fb17097f7000cd" => :catalina
    sha256 "73d4d1936a7862127e77efa45a07af5e4b49ed00227e9455671ca2a87a32875c" => :mojave
    sha256 "8799c5a87853dba2a74a3cbc58a7ecb39197ade8372726d044f617ca6bf55a33" => :high_sierra
    sha256 "2e81e914a8259d6f97e808d4def682154d45545efc6efc67c2c344dc5e97e1d8" => :sierra
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
