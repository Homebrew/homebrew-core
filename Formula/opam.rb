class Opam < Formula
  desc "OCaml package manager"
  homepage "https://opam.ocaml.org"
  url "https://github.com/ocaml/opam/releases/download/2.0.8/opam-full-2.0.8.tar.gz"
  sha256 "7b9d29233d9633ef50ba766df2e39112b15cd05c1c6fedf80bcb548debcdd9bd"
  license "LGPL-2.1"
  head "https://github.com/ocaml/opam.git"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, big_sur:     "34baee7b82515f19b8b5163bb8dd410128519e67635c079e392fc35b4625deb9"
    sha256 cellar: :any_skip_relocation, catalina:    "2b1115dfcdfe71a806d07da60597a76f0e531c828e33e2c2c9901b0ef343c285"
    sha256 cellar: :any_skip_relocation, mojave:      "39900786c86d1534586d261ced1876e9d0a90d119d41b37ba7eb2fbed948c033"
    sha256 cellar: :any_skip_relocation, high_sierra: "2d363ac12943a0505c55b9fe3249a5f12b37d666d6b811e374908ae2cbd22626"
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
