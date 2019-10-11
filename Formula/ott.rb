class Ott < Formula
  desc "Tool for writing definitions of programming languages and calculi"
  homepage "https://www.cl.cam.ac.uk/~pes20/ott/"
  url "https://github.com/ott-lang/ott/archive/0.28.tar.gz"
  sha256 "30c7613802cdd7f03eb1df1d634da3e13197e210d5697252382d29b5f03618f2"
  head "https://github.com/ott-lang/ott.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "2e9d2682f185656de583c42df9b99b3a23e1d167f7cfb366d97d74e9d728c9f9" => :catalina
    sha256 "a64451a61a2d6cb0d34e327459bdd789233d8acc2fd89673b931220a7780b869" => :mojave
    sha256 "d590c5c215ca73f47baceb8c851836c1e9ea0d78fcb6f253c02568c6db56a65d" => :high_sierra
    sha256 "d2132bd134e79d0e73a4b4ea6e23363f9b14ade49b550fa65b5744dc41c35fd9" => :sierra
    sha256 "12177801e7faf22a9d875d6c0e222fd7eff9fcab5755f5a6266223296ec01ef4" => :el_capitan
  end

  depends_on "ocaml" => :build

  def install
    system "make", "world"
    bin.install "bin/ott"
    pkgshare.install "examples"
    (pkgshare/"emacs/site-lisp/ott").install "emacs/ott-mode.el"
  end

  test do
    system "#{bin}/ott", "-i", pkgshare/"examples/peterson_caml.ott",
      "-o", "peterson_caml.tex", "-o", "peterson_caml.v"
  end
end
