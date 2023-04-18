class Opam < Formula
  desc "OCaml package manager"
  homepage "https://opam.ocaml.org"
  url "https://github.com/ocaml/opam/releases/download/2.1.4/opam-full-2.1.4.tar.gz"
  sha256 "1643609f4eea758eb899dc8df57b88438e525d91592056f135e6e045d0d916cb"
  license "LGPL-2.1-only"
  head "https://github.com/ocaml/opam.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4203dd8ed7d01e2e27c226f41cde68f797433b39cea3b32d5f265205aad3c0d9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "442fda0ec64b42667e5299217e1053057fed3c0c2f84685302fa8f1fb4fa72c0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6462d0f11704126247331049f1e737ae459b8bb11459534a673caf2a4b834938"
    sha256 cellar: :any_skip_relocation, ventura:        "a392de4983f5be70c57469250d82bb81e08ec32f88fec9a755b678ac285b8898"
    sha256 cellar: :any_skip_relocation, monterey:       "507ad56c58cd33a903932870720154be8a4bac7a53dbf26cbc54ab1e0d200d87"
    sha256 cellar: :any_skip_relocation, big_sur:        "b7d269a8eacb55dfa391b361711cace261aff40941137d015f1f2fa0a7c8c0e3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c2212e56b77c1c3c591ced93249ea9cd12f2a6eeebda161569b1c013938fb2b3"
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
