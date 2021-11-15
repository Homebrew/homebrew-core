class Opam < Formula
  desc "OCaml package manager"
  homepage "https://opam.ocaml.org"
  url "https://github.com/ocaml/opam/releases/download/2.1.1/opam-full-2.1.1.tar.gz"
  sha256 "97ed14ac4dcd5b9ab41dc7689ba29eb4fddfe9708124727b64bb6027644d01ec"
  license "LGPL-2.1-only"
  head "https://github.com/ocaml/opam.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a1857425c84f28023915f3c211098a7f278ad39040a1c569a22ccd88a2a6ef10"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9bbb374ac9f15d245e0c7e6f8082ef88aa81a6d808a2cea5dd6a0bd08c21cd4c"
    sha256 cellar: :any_skip_relocation, monterey:       "8a038c6f7a24ca54295c24d921950d1b42590f7f2e7b343b33ab1b9f1047bf91"
    sha256 cellar: :any_skip_relocation, big_sur:        "17f550490c8bfe2159fedcd830aac382c6b0bb5a40af26da6ce59c7943d93809"
    sha256 cellar: :any_skip_relocation, catalina:       "9a2ebda132ee358956a7010a677731f58776d7b6bc33100e3848e900978c2c37"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5fffb9378c88c700679ac7640cd6d0ecd66d36397632baa906b29e5d8cc607eb"
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
