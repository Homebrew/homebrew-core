class Opam < Formula
  desc "OCaml package manager"
  homepage "https://opam.ocaml.org"
  url "https://github.com/ocaml/opam/releases/download/2.1.2/opam-full-2.1.2.tar.gz"
  sha256 "de1e3efffd5942e0101ef83dcdead548cc65a93e13986aecb4a264a059457ede"
  license "LGPL-2.1-only"
  head "https://github.com/ocaml/opam.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5d6d0d434b180b861eb18ffae3b70bc8235479b00956248e5cc485ccae2f8d26"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3c9b2b9d9e17b328ed640a3b656e5cdf917f2854fe2678cf56392199142814a3"
    sha256 cellar: :any_skip_relocation, monterey:       "316167256d1f2754a45ca9cac05b6c055057902093413f0edd6df736521f70be"
    sha256 cellar: :any_skip_relocation, big_sur:        "35c725a04e60011bbb4dec521b5dfb66725d363010e995e1a6cffa969c1b2da0"
    sha256 cellar: :any_skip_relocation, catalina:       "186d8a3aa61e1bab81dda6832f295239fb308ae997dad0727d8170e2fc70b358"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4e30f437ea3e56fee4f7849ebedc5cf27eb09818c1ca5b6fa52485c793a7c678"
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
