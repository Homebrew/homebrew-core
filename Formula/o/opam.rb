class Opam < Formula
  desc "OCaml package manager"
  homepage "https://opam.ocaml.org"
  url "https://github.com/ocaml/opam/releases/download/2.1.5/opam-full-2.1.5.tar.gz"
  sha256 "09f8d9e410b2f5723c2bfedbf7970e3b305f5017895fcd91759f05e753ddcea5"
  license "LGPL-2.1-only"
  head "https://github.com/ocaml/opam.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b3d4ccb326e47de617cfec7bfff3c2c7efc74af2cf351708456764f3a12ace9b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "293d7ed182ded705c19b2d2b87810d81354f8701a5791dcce544c518cd1ca9c8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4bd4718ce250e478c62c714876ffb16128967d86500c4c6c48e6819fc07a91f7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "16d8c6268d2b4474b90e03212ee19b3c9e1da708ab9aa6b4b162c6d6856e394a"
    sha256 cellar: :any_skip_relocation, sonoma:         "3a3b6ea7347d167e4ed242d1baccecb9a61288d600524e7e98f769ebff1d9996"
    sha256 cellar: :any_skip_relocation, ventura:        "89e37cbf2695af2f9e33ec8b3386f77e7cfebc671e8112c03faea2a87a4c89a8"
    sha256 cellar: :any_skip_relocation, monterey:       "ad2ce1268bd0383603a0d197ea19238b6c042112e3f71c65b32a41ebc7b86ae0"
    sha256 cellar: :any_skip_relocation, big_sur:        "ab77225e549e373c6f3a565ca93992a5e01c0388c80ea067a5bfb9f9ba2f4768"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d4e7a70b75af7a924fc19af6ed8575697d519eb0e86250d294e190d432ee6d93"
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
