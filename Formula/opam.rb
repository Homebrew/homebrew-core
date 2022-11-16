class Opam < Formula
  desc "OCaml package manager"
  homepage "https://opam.ocaml.org"
  url "https://github.com/ocaml/opam/releases/download/2.1.3/opam-full-2.1.3.tar.gz"
  sha256 "cb2ab00661566178318939918085aa4b5c35c727df83751fd92d114fdd2fa001"
  license "LGPL-2.1-only"
  head "https://github.com/ocaml/opam.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b02e96f6dfc96d76e790d03cc6baca328f191bd7fea3d3fe569a345473acf855"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8563eb7d39ff28e820a742a93b43a792b51015abefb7f717addeb37940749000"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0c36da51223f65fd44a96d112fe39541fa7250a73350bad309d5a65ba2e894ef"
    sha256 cellar: :any_skip_relocation, ventura:        "247bbb505091dda216a9cc5a44348ca1e94521173ffbe395ee5ead39a96c8137"
    sha256 cellar: :any_skip_relocation, monterey:       "b716d483047de32ecef958e0a0169240735fa1193522746c673e09414bd3acd0"
    sha256 cellar: :any_skip_relocation, big_sur:        "78675942dcb92da0acc6c0f156a86a5068aa628e093f661ec6d0bbbc4bcbd968"
    sha256 cellar: :any_skip_relocation, catalina:       "dfa026d9771b2942d7eb6157eb8cff877b94de1f15f581ad2b7e3c48db8535ab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2034d975561c9fd928d95cb82c45268f8a15f1fe30c7d6e953b22f99ba3f43e2"
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
    system bin/"opam", "init", "--auto-setup", "--disable-sandboxing"
    system bin/"opam", "list"
  end
end
