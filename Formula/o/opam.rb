class Opam < Formula
  desc "OCaml package manager"
  homepage "https://opam.ocaml.org"
  url "https://github.com/ocaml/opam/releases/download/2.1.6/opam-full-2.1.6.tar.gz"
  sha256 "d2af5edc85f552e0cf5ec0ddcc949d94f2dc550dc5df595174a06a4eaf8af628"
  license "LGPL-2.1-only"
  head "https://github.com/ocaml/opam.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bd28b8b714495d2e9fd0352f88a85cb9d76934d4be096ca6cac4a9659166ad8e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9852a6d29fc54a99e1b04f1b77560c74474f216f31679fbad8b152d29ce257fb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0d70be910bfb8bc6c89e8ee21b5b8c235498cb26947d8b0d30144ee15a18ffac"
    sha256 cellar: :any_skip_relocation, sonoma:         "b3b3b3c4214bdf6696658afc26b63354b689a7cd3bdf94126e7b3fb5e72a7677"
    sha256 cellar: :any_skip_relocation, ventura:        "df569da764f1b28815e82f3d66855834c0888f5b2b839bfd90b7ab426f360a73"
    sha256 cellar: :any_skip_relocation, monterey:       "5861b830e1d5f756ba740b1bc2960e1427f6e276971bbddfc57038924bdf9fe4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6ef8a0be549a090556a17909a86746cc815021e4593b7fedaa87c938ca98e8ff"
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
